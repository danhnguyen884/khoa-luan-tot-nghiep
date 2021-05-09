import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseController {
  static FirebaseController get instanace => FirebaseController();

  // Save Image to Storage
  Future<String> saveUserImageToFirebaseStorage(userId,userName,userIntro,userImageFile,email) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId',userId);
      await prefs.setString('name',userName);
      await prefs.setString('intro',userIntro);
      await prefs.setString('email',email);

      String filePath = 'userImages/$userName';
      final StorageReference storageReference = FirebaseStorage().ref().child(filePath);
      final StorageUploadTask uploadTask = storageReference.putFile(userImageFile);

      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      String imageURL = await storageTaskSnapshot.ref.getDownloadURL(); // Image URL from firebase's image file
      String result = await saveUserDataToFirebaseDatabase(userId,userName,userIntro,imageURL,email);
      return result;
    }catch(e) {
      print(e.message);
      return null;
    }
  }

  Future<String> sendImageToUserInChatRoom(croppedFile,chatID) async {
    try {
      String imageTimeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      String filePath = 'ChatRoom/$chatID/$imageTimeStamp';
      final StorageReference storageReference = FirebaseStorage().ref().child(filePath);
      final StorageUploadTask uploadTask = storageReference.putFile(croppedFile);
      StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
      String result = await storageTaskSnapshot.ref.getDownloadURL();
      return result;
    }catch(e) {
      print(e.message);
    }
  }

  // About Firebase Database
  Future<String> saveUserDataToFirebaseDatabase(userId,userName,userIntro,downloadUrl,email) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final QuerySnapshot result = await Firestore.instance.collection('users').where("name", isEqualTo: userName).getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      String myID = userId;
      if (documents.length == 0) {
        await Firestore.instance.collection('users').document(userId).setData({
          'userId':userId,
          'name':userName,
          'intro':userIntro,
          'userImageUrl':downloadUrl,
          'email' :null
        });
      }else {
        String userID = documents[0]['userId'];
        myID = userID;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId',myID);
        await Firestore.instance.collection('users').document(userID).updateData({
          'name':userName,
          'intro':userIntro,
          'userImageUrl':downloadUrl,
          'email' :null
        });
      }
      return myID;
    }catch(e) {
      print(e.message);
      return null;
    }
  }

  Future<void> updateUserToken(userID, token) async {
    await Firestore.instance.collection('users').document(userID).setData({
      'FCMToken':token,
    });
  }

  Future<List<DocumentSnapshot>> takeUserInformationFromFBDB() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final QuerySnapshot result = await Firestore.instance.collection('users').where('FCMToken', isEqualTo: prefs.get('FCMToken') ?? 'None').getDocuments();
    return result.documents;
  }

  Future<int> getUnreadMSGCount([String peerUserID]) async{
    try {
      int unReadMSGCount = 0;
      String targetID = '';
      SharedPreferences prefs = await SharedPreferences.getInstance();

      peerUserID == null ? targetID = (prefs.get('userId') ?? 'NoId') : targetID = peerUserID;
//      if (targetID != 'NoId') {
        final QuerySnapshot chatListResult =
        await Firestore.instance.collection('users').document(targetID).collection('chatlist').getDocuments();
        final List<DocumentSnapshot> chatListDocuments = chatListResult.documents;
        for(var data in chatListDocuments) {
          final QuerySnapshot unReadMSGDocument = await Firestore.instance.collection('chatroom').
          document(data['chatID']).
          collection(data['chatID']).
          where('idTo', isEqualTo: targetID).
          where('isread', isEqualTo: false).
          getDocuments();

          final List<DocumentSnapshot> unReadMSGDocuments = unReadMSGDocument.documents;
          unReadMSGCount = unReadMSGCount + unReadMSGDocuments.length;
        }
        print('unread MSG count is $unReadMSGCount');
//      }
      if (peerUserID == null) {
        FlutterAppBadger.updateBadgeCount(unReadMSGCount);
        return null;
      }else {
        return unReadMSGCount;
      }

    }catch(e) {
      print(e.message);
    }
  }

  Future updateChatRequestField(String documentID,String lastMessage,chatID,myID,selectedUserID) async{
    await Firestore.instance
        .collection('users')
        .document(documentID)
        .collection('chatlist')
        .document(chatID)
        .setData({'chatID':chatID,
      'chatWith':documentID == myID ? selectedUserID : myID,
      'lastChat':lastMessage,
      'timestamp':DateTime.now().millisecondsSinceEpoch});
  }

  Future sendMessageToChatRoom(chatID,messageMap) async {
    await Firestore.instance
        .collection('ChatRoom')
        .document(chatID)
        .collection('chats')
        .add(messageMap).catchError((e){print(e.toString());});
  }
}