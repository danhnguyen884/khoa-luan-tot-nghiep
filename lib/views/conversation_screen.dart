import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/controllers/firebaseController.dart';
import 'package:chat_app/controllers/fullphoto.dart';
import 'package:chat_app/controllers/pickImageController.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/modul/user.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/callscreens/permissions.dart';
import 'package:chat_app/views/callscreens/video_room.dart';
import 'package:chat_app/views/chatRoomsScreen.dart';
import 'package:chat_app/widgets/pagevideo.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'callscreens/call_utilities.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String selectedUser;

  ConversationScreen({this.chatRoomId,this.selectedUser});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  String messageType = 'text';
  bool _isLoading = false;
  Stream chatMessageStream;
  Widget ChatMessageList() {
    return Container(
      child: StreamBuilder(
          stream: chatMessageStream,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return snapshot.data.documents[index].data["type"] ==
                              'text'
                          ? MessageTile(
                              (snapshot.data.documents[index].data["message"]),
                              snapshot.data.documents[index].data["sendBy"] ==
                                  Constants.myName,returnTimeStamp(snapshot.data.documents[index].data["time"]))
                          : ((snapshot.data.documents[index].data["sendBy"] ==
                                  Constants.myName)
                              ? _imageMessageFromMe(snapshot
                                  .data.documents[index].data["message"],returnTimeStamp(snapshot.data.documents[index].data["time"]))
                              : _imageMessage(snapshot
                                  .data.documents[index].data["message"],returnTimeStamp(snapshot.data.documents[index].data["time"])));
                    },
                  )
                : Text('Error');
          }),
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
        "type": "text"
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    super.initState();
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });


  }

  @override
  Widget build(BuildContext context) {
    String name =widget.selectedUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Container(
          alignment: Alignment.centerLeft,
          //padding: EdgeInsets.only(left: 25, top: 40),
          child: IconButton(
              iconSize: 25,
              icon: Icon(
                Icons.arrow_back,
                color: Colors.purple,
              ),
              onPressed: () {
                return Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ChatRoom()));
              }
          ),
        ),
        title: name!=null? Text('${widget.selectedUser}',style: TextStyle(color: Colors.black)):Text('ChatRoom',style: TextStyle(color: Colors.black),) ,
        actions: [
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {  },
            color: Colors.purple,
          ),
          IconButton(
            color: Colors.purple,
            icon: Icon(Icons.video_call),
              onPressed: () async =>
              await Permissions.cameraAndMicrophonePermissionsGranted()?
              {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => VideoPage()))
              }:{}
              // onPressed: () async =>
              // await Permissions.cameraAndMicrophonePermissionsGranted()
              //     ? CallUtils.dial(
              //   from: sender,//sender,
              //   to: getUserData(widget.selectedUser),//widget.receiver,
              //   context: context,
              // )
              //     : {},
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                        icon: new Icon(
                          Icons.photo,
                          color: Colors.cyan[900],
                        ),
                        onPressed: () {
                          PickImageController.instance
                              .cropImageFromFile()
                              .then((croppedFile) {
                            if (croppedFile != null) {
                              setState(() {
                                messageType = 'image';
                              });
                              _saveUserImageToFirebaseStorage(croppedFile);
                            } else {
                              // showAlertDialog(context,'Pick Image error');
                            }
                          });
                        }),
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(color: Colors.black54),
                        decoration: InputDecoration(
                            hintText: "Message...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        child: Image.asset("assets/images/send.png",color: Colors.black,),
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              const Color(0x36FFFFFF),
                              const Color(0xFFFFFFF)
                            ]),
                            borderRadius: BorderRadius.circular(40)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveUserImageToFirebaseStorage(croppedFile) async {
    try {
      String takeImageURL = await FirebaseController.instanace
          .sendImageToUserInChatRoom(croppedFile, widget.chatRoomId);
      _handleSubmitted(takeImageURL);
    } catch (e) {
      //_showDialog('Error add user image to storage');
    }
  }

  Future<void> _handleSubmitted(String text) async {
    try {
      if (text != null) {
        Map<String, dynamic> messageMap = {
          "message": text,
          "sendBy": Constants.myName,
          "time": DateTime.now().millisecondsSinceEpoch,
          "type": "photo"
        };
        databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
        messageController.text = "";
      }
      // await FirebaseController.instanace.sendMessageToChatRoom(widget.chatRoomId,widget.myID,widget.selectedUserID,text,messageType);
      // await FirebaseController.instanace.updateChatRequestField(widget.selectedUserID, messageType == 'text' ? text : '(Photo)',widget.chatRoomId,widget.myID,widget.selectedUserID);
      // await FirebaseController.instanace.updateChatRequestField(widget.myID, messageType == 'text' ? text : '(Photo)',widget.chatRoomId,widget.myID,widget.selectedUserID);
      //_getUnreadMSGCountThenSendMessage();
    } catch (e) {
      _showDialog('Error user information to database');
      _resetTextFieldAndLoading();
    }
  }

  _resetTextFieldAndLoading() {
    FocusScope.of(context).requestFocus(FocusNode());
    messageController.text = '';
    setState(() {
      _isLoading = false;
    });
  }

  _showDialog(String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(msg),
          );
        });
  }

  Widget _imageMessage(imageUrlFromFB,time) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top:2.0,right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(0,8,4,8),
                child : Container(
                  constraints: BoxConstraints(maxWidth: size.width - size.width*0.20),
                  decoration: BoxDecoration(
                    color:  Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Container(
                      child: Container(
                        //constraints: BoxConstraints(maxWidth: size.width - size.width*0.26),
                        //padding: EdgeInsets.only(left: 250.0),
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FullPhoto(url: imageUrlFromFB)));
                          },
                          child: CachedNetworkImage(
                            imageUrl: imageUrlFromFB,
                            placeholder: (context, url) => Container(
                              transform: Matrix4.translationValues(0, 0, 0),
                              child: Container(
                                  width: 60,
                                  height: 80,
                                  child: Center(child: new CircularProgressIndicator())),
                            ),
                            errorWidget: (context, url, error) => new Icon(Icons.error),
                            width: 60,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom:14.0, right: 4,left:8),
            child: Text(time,style: TextStyle(fontSize: 12),),
          ),
        ],
      ),
    );
  }

  Widget _imageMessageFromMe(imageUrlFromFB,time) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top:2.0,right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom:14.0, right: 4,left:8),
            child: Text(time,style: TextStyle(fontSize: 12),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(0,8,4,8),
              child : Container(
                  constraints: BoxConstraints(maxWidth: size.width - size.width*0.20),
                decoration: BoxDecoration(
                  color:  Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Container(
                    child: Container(
                      //constraints: BoxConstraints(maxWidth: size.width - size.width*0.26),
                      //padding: EdgeInsets.only(left: 250.0),
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullPhoto(url: imageUrlFromFB)));
                        },
                        child: CachedNetworkImage(
                          imageUrl: imageUrlFromFB,
                          placeholder: (context, url) => Container(
                            transform: Matrix4.translationValues(0, 0, 0),
                            child: Container(
                                width: 60,
                                height: 80,
                                child: Center(child: new CircularProgressIndicator())),
                          ),
                          errorWidget: (context, url, error) => new Icon(Icons.error),
                          width: 60,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  final String time;

  MessageTile(this.message, this.isSendByMe, this.time);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
        left: isSendByMe ? 150 : 0, right: isSendByMe ? 0 : 150),
          child: Padding(
            padding: const EdgeInsets.only(bottom:0, right: 4,left:8,top: 14.0),
            child: Text(time,style: TextStyle(fontSize: 12),),
          ),
        ),
        Container(
            padding: EdgeInsets.only(
                left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
            margin: EdgeInsets.symmetric(vertical: 8),
            width: MediaQuery.of(context).size.width,
            alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isSendByMe
                        ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                        : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
                  ),
                  borderRadius: isSendByMe
                      ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23),
                  )
                      : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23),
                  )),
              child: Column(
                children: [
                  Text(message,
                      style: TextStyle(color: Colors.white, fontSize: 17)),

                ],
              ),
            ))
      ],
    );
  }
}

String returnTimeStamp(int messageTimeStamp) {
  String resultString = '';
  var format = DateFormat('hh:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(messageTimeStamp);
  resultString = format.format(date);
  return resultString;
}
