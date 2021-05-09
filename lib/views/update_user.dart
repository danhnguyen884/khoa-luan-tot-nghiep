import 'dart:io';

import 'package:chat_app/controllers/firebaseController.dart';
import 'package:chat_app/controllers/pickImageController.dart';
import 'package:chat_app/controllers/utils.dart';
import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/views/chatRoomsScreen.dart';
import 'package:chat_app/views/smal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widgets/flutter_widgets.dart';

class UpdateUser extends StatefulWidget {
  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _introTextController = TextEditingController();
  File _userImageFile = File('');
  String _userImageUrlFromFB = '';
  AuthMethods authMethods = new AuthMethods();
  bool _isLoading = true;

  @override
  void initState() {
    // NotificationController.instance.takeFCMTokenWhenAppLaunch();
    // NotificationController.instance.initLocalNotification();
    // setCurrentChatRoomID('none');
    // _takeUserInformationFromFBDB();
    super.initState();
  }

  // _takeUserInformationFromFBDB() async {
  //   FirebaseController.instanace.takeUserInformationFromFBDB().then((documents) {
  //     if (documents.length > 0) {
  //       _nameTextController.text = documents[0]['name'];
  //       _introTextController.text = documents[0]['intro'];
  //       setState(() {
  //         _userImageUrlFromFB = documents[0]['userImageUrl'];
  //       });
  //     }
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 50,
        ),
        leading: IconButton(
            iconSize: 30,
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: (){
               return Navigator.push(
                   context, MaterialPageRoute(builder: (context) => ChatRoom()));
            }
        ),
        // leading: IconButton(
        //   icon: Icon(Icons.menu),
        //   tooltip: 'Menu Icon',
        //   onPressed: () {},
        // ),
        actions: <Widget>[
          // IconButton(
          //   onPressed: (){
          //     Navigator.pushReplacement(context,
          //         MaterialPageRoute(builder: (context) => UpdateUser()));
          //   },
          //   icon: Icon(Icons.settings),
          // ),
          GestureDetector(
            onTap: () {
              authMethods.signOut();
                      Navigator.pushReplacement(context,
                           MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: Container(
              child: Icon(Icons.exit_to_app),
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your Information.',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: GestureDetector(
                          onTap: () {
                            PickImageController.instance
                                .cropImageFromFile()
                                .then((croppedFile) {
                              if (croppedFile != null) {
                                setState(() {
                                  _userImageFile = croppedFile;
                                  _userImageUrlFromFB = '';
                                });
                              } else {
                                _showDialog('Pick Image error');
                              }
                            });
                          },
                          child: Container(
                            width: 140,
                            height: 160,
                            child: Card(
                              child: _userImageUrlFromFB != ''
                                  ? Image.network(_userImageUrlFromFB)
                                  : (_userImageFile.path != '')
                                      ? Image.file(_userImageFile,
                                          fit: BoxFit.fill)
                                      : Icon(Icons.add_photo_alternate,
                                          size: 60, color: Colors.grey[700]),
                            ),
                          ))),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.account_circle,color: Colors.lightBlue,),

                              labelText: 'Name',
                              labelStyle: TextStyle(color: Colors.black54),
                              hintText: 'Type Name',
                          hintStyle: TextStyle(color: Colors.black54)),
                          controller: _nameTextController,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.note,color: Colors.lightBlue,),
                              labelText: 'Intro',
                              hintStyle: TextStyle(color: Colors.black54),
                              labelStyle: TextStyle(color: Colors.black54),

                              hintText: 'Type Intro'),
                          controller: _introTextController,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Go to Chat list',
                          style: TextStyle(fontSize: 28),
                        )
                      ],
                    ),
                    textColor: Colors.white,
                    color: Colors.green[700],
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    onPressed: () {
                       _saveDataToServer();
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (context) => ChatRoom()));
                    },
                  )),
              //_youtubeTitle(),
              // _youtubeLinkTitle(),
              // _youtubeLinkAddress(),
              //_youtubeImage()
            ],
          ),
          // Positioned(
          //   // Loading view in the center.
          //   child: _isLoading
          //       ? Container(
          //     child: Center(
          //       child: CircularProgressIndicator(),
          //     ),
          //     color: Colors.white.withOpacity(0.7),
          //   )
          //       : Container(),
          // ),
        ],
      ),
    );
  }

  Widget _youtubeTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, top: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Loyd Lab (Youtube)',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _youtubeLinkTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Youtube link: ',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _youtubeLinkAddress() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () {
            //launchURL();
          },
          // child: Text(
          //   youtubeChannelLink,
          //   style: TextStyle(
          //     fontSize: 14,
          //     color: Colors.blue[700],
          //     decoration: TextDecoration.underline,
          //   ),
          // ),
        ),
      ),
    );
  }

  Widget _youtubeImage() {
    return Expanded(child: Image.asset('images/youtube_screenshot.png'));
  }

  _saveDataToServer() {
    setState(() {
      _isLoading = true;
    });
    String alertString = checkValidUserData(_userImageFile, _userImageUrlFromFB,
        _nameTextController.text, _introTextController.text);
    if (alertString.trim() != '') {
      _showDialog(alertString);
    } else {
      _userImageUrlFromFB != ''
          ? FirebaseController.instanace.saveUserDataToFirebaseDatabase(randomIdWithName(_nameTextController.text),
          _nameTextController.text,_introTextController.text,_userImageUrlFromFB,null).then((data){
        _moveToChatList(data);
      })
          : FirebaseController.instanace.saveUserImageToFirebaseStorage(
          randomIdWithName(_nameTextController.text),_nameTextController.text,_introTextController.text,
          _userImageFile,null).then((data){
        _moveToChatList(data);
      });
    }
  }

  _moveToChatList(data) {
    setState(() { _isLoading = false; });
    if(data != null) {
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => ChatRoom()));
    }
    else { _showDialog('Save user data error'); }
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
}
