import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/controllers/firebaseController.dart';
import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/modul/user.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/theme/style.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/views/settings_view.dart';
import 'package:chat_app/views/signin.dart';
import 'package:chat_app/views/update_user.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom>
    with SingleTickerProviderStateMixin {
  AuthMethods authMethods = new AuthMethods();
  final Firestore fb = Firestore.instance;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomsStream;
  Stream userStream;
  UserData _user;
  String _receiver;
  bool isMin = true;
  AnimationController animationController;

  UserData get getUser => _user;

  Widget _chatRoomList() {
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    _receiver = snapshot
                        .data.documents[index].data["chatroomid"]
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, "");
                    return ChatRoomTile(
                        snapshot.data.documents[index].data["chatroomid"]
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(Constants.myName, ""),
                        snapshot.data.documents[index].data["chatroomid"],
                        snapshot.data.documents[index].data["chatroomid"]
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(Constants.myName, ""));
                  })
              : Container();
        });
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    getUserInfo();
    //getUserInfoImage();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomsStream = value;
        print(
            "we got the data + ${chatRoomsStream.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  getUserInfoImage() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getUserImage(Constants.myName).then((value) {
      setState(() {
        userStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).appBarTheme.color;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Chats',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black54,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      // appBar: AppBar(
      //   title: Image.asset(
      //     "assets/images/logo.png",
      //     height: 50,
      //   ),
      //   leading: IconButton(
      //     icon: Icon(Icons.menu),
      //     tooltip: 'Menu Icon',
      //     onPressed: () {
      //       setState(() {});
      //     },
      //   ),
      //   actions: <Widget>[
      //     IconButton(
      //       onPressed: () {
      //         return Navigator.pushReplacement(context,
      //             MaterialPageRoute(builder: (context) => UpdateUser()));
      //       },
      //       icon: Icon(Icons.settings),
      //     ),
      //     GestureDetector(
      //       onTap: () {
      //         authMethods.signOut();
      //         Navigator.pushReplacement(context,
      //             MaterialPageRoute(builder: (context) => Authenticate()));
      //       },
      //       child: Container(
      //         child: Icon(Icons.exit_to_app),
      //         padding: EdgeInsets.symmetric(horizontal: 16),
      //       ),
      //     )
      //   ],
      // ),
      //body: chatRoomList(),
      body: _chatRoomList(),
      bottomNavigationBar: _navigationBar(),
      floatingActionButton: Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Container(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [Colors.deepOrangeAccent, Colors.red, Colors.pink],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  tileMode: TileMode.clamp),
            ),
            child: FloatingActionButton(
              elevation: .0,
              highlightElevation: .0,
              foregroundColor: Colors.white,
              splashColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              child: isMin
                  ? Padding(
                      padding: EdgeInsets.all(12.0),
                      // child: SvgPicture.asset(
                      //   assets + "heart.svg",
                      //   color: Colors.white,
                      // ),
                    child: Icon(
                      Icons.add,
                      size: 35.0,
                      color: Colors.black87,
                    ),
                    )
                  : FadeTransition(
                      opacity: animationController.drive(
                        CurveTween(curve: Curves.easeOut),
                      ),
                      child: Icon(
                        Icons.clear,
                        size: 35.0,
                      ),
                    ),
              onPressed: () {
                isMin = isMin ? false : true;
                isMin
                    ? animationController.reverse()
                    : animationController.forward();
                setState(() {});
              },
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.search),
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => SearchScreen()));
      //   },
      // ),
    );
  }

  Widget _bottomNavigationBar() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: _navigationBar(),
      floatingActionButton: Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Container(
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [Colors.deepOrangeAccent, Colors.red, Colors.pink],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  tileMode: TileMode.clamp),
            ),
            child: FloatingActionButton(
              elevation: .0,
              highlightElevation: .0,
              foregroundColor: Colors.white,
              splashColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              child: isMin
                  ? Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        assets + "heart.svg",
                        color: Colors.white,
                      ),
                    )
                  : FadeTransition(
                      opacity: animationController.drive(
                        CurveTween(curve: Curves.easeOut),
                      ),
                      child: Icon(
                        Icons.clear,
                        size: 35.0,
                      ),
                    ),
              onPressed: () {
                isMin = isMin ? false : true;
                isMin
                    ? animationController.reverse()
                    : animationController.forward();
                setState(() {});
              },
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _navigationBar() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
      height: isMin ? 50.0 : 400.0,
      color: Colors.black26,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
        child: BottomAppBar(
          elevation: .0,
          notchMargin: 10.0,
          shape: CircularNotchedRectangle(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                _iconsNavigationBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: FadeTransition(
                      opacity: animationController.drive(
                        CurveTween(curve: Curves.easeOut),
                      ),
                      child: _footerNavigationBar(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconsNavigationBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: SvgPicture.asset(
            "assets/home.svg",
            color: Colors.black87,
            width: 23.0,
          ),
          onPressed: () {
            return Navigator.push(
                context, MaterialPageRoute(builder: (context) => ChatRoom()));
          },
        ),
        Padding(
          padding: EdgeInsets.only(right: 40),
          child: IconButton(
            icon: SvgPicture.asset(
              "assets/search.svg",
              color: Colors.black87,
              width: 23.0,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 40),
          child: IconButton(
            icon: SvgPicture.asset(
              "assets/layers.svg",
              color: Colors.black87,
              width: 23.0,
            ),
            onPressed: () {},
          ),
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/user.svg",
            color: Colors.black87,
            width: 23.0,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SettingsView()));
          },
        ),
      ],
    );
  }

  Widget _footerNavigationBar() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 15.0),
      padding: EdgeInsets.only(
        top: 20.0,
        left: 15.0,
        right: 15.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color.fromRGBO(240, 240, 240, 1.0)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Need advice?",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(
            "What are you looking for?",
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(color: Style.subTitle),
          ),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _footerIcons(
                assets + "doctor.svg",
                "Doctor",
                [Colors.purple, Colors.pinkAccent],
              ),
              _footerIcons(
                assets + "stethoscope.svg",
                "Consultation",
                [Colors.deepPurpleAccent, Colors.blue],
              ),
              _footerIcons(
                assets + "ambulance.svg",
                "Ambulance",
                [Colors.orange, Colors.redAccent],
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _footerIcons(
                assets + "medical.svg",
                "Medical",
                [Colors.greenAccent, Colors.teal],
              ),
              _footerIcons(
                assets + "medal.svg",
                "Awards",
                [Colors.greenAccent, Colors.cyan],
              ),
              _footerIcons(
                assets + "healthcare.svg",
                "Help",
                [Colors.blue, Colors.cyan],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footerIcons(String path, String title, List<Color> colors) {
    return Column(
      children: [
        Container(
          width: 75.0,
          height: 75.0,
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.1),
                spreadRadius: 4,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                tileMode: TileMode.clamp,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: SvgPicture.asset(path),
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .subtitle2
              .copyWith(color: Colors.white),
        ),
      ],
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final String selectedUser;

  ChatRoomTile(this.userName, this.chatRoomId, this.selectedUser);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(
                      chatRoomId: chatRoomId,
                      selectedUser: selectedUser,
                    )));
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              //color: Colors.white,
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(40)),
              child: Text(
                "${userName.substring(0, 1).toUpperCase()}",
                style: mediumTextStyle(),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "$userName",
              style: mediumTextStyle(),
            ),
            SizedBox(
              width: 8,
            ),
            // ClipRect(
            //   child: CachedNetworkImage(
            //     imageUrl:
            //         'https://images.unsplash.com/photo-1618769122188-83fd83ec02fa?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1400&q=80',
            //     placeholder: (context, url) => Container(
            //       transform: Matrix4.translationValues(0, 0, 0),
            //       child: Container(
            //           width: 60,
            //           height: 80,
            //           child: Center(child: new CircularProgressIndicator())),
            //     ),
            //     errorWidget: (context, url, error) => new Icon(Icons.error),
            //     width: 60,
            //     height: 80,
            //     fit: BoxFit.cover,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

Widget ImageList() {
  return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView(
                children: snapshot.data.documents.map(
                (data) {
                  ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: CachedNetworkImage(
                              imageUrl: data['userImageUrl'],
                              placeholder: (context, url) => Container(
                                transform: Matrix4.translationValues(0, 0, 0),
                                child: Container(
                                    width: 60,
                                    height: 80,
                                    child: Center(
                                        child:
                                            new CircularProgressIndicator())),
                              ),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                              width: 60,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      });
                },
              ).toList())
            : Container();
      });
}
