

import 'package:chat_app/modul/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class DatabaseMethods {
  UserData user = UserData();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final CollectionReference _userCollection =
  _firestore.collection("users");
  static final Firestore _firestore = Firestore.instance;
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<UserData> getUserDetails() async {
    FirebaseUser currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
    await _userCollection.document(currentUser.uid).get();

    return UserData.fromMap(documentSnapshot.data);
  }
  // Future<UserData> getUserDetailsByName(String name) async {
  //   FirebaseUser currentUser = await getCurrentUser();
  //
  //   DocumentSnapshot documentSnapshot =
  //   await _userCollection.document(name).get();
  //
  //   return UserData.fromMap(documentSnapshot.data);
  // }
  getUserByUsername(String username) async{
    return await Firestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .getDocuments();
  }
  getUserByUserEmail(String userEmail) async{
    return await Firestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .getDocuments();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection("users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap){
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId).setData(chatRoomMap).catchError((e){
          print(e.toString());
    });

  }
  addConversationMessages(String chatRoomId,messageMap){
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e){print(e.toString());});
  }
  getConversationMessages(String chatRoomId)async {
    return await Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
    .orderBy("time",descending: false)
        .snapshots();
  }
  getChatRooms(String userName) async{
    return await Firestore.instance
        .collection("ChatRoom")
        .where("users",arrayContains: userName)
        .snapshots();
  }
  getUserImage(String userName) async{
    return await Firestore.instance
        .collection("users")
        .where("userImageUrl",isEqualTo: userName)
        .snapshots().toString();
  }
}
