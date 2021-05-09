import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}
String _myName;
class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController =
      new TextEditingController();

  QuerySnapshot searchSnapshot;


  initiateSearch() {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                  userName: searchSnapshot.documents[index].data["name"],
                  userEmail: searchSnapshot.documents[index].data["email"]);
            },
          )
        : Container();
  }

  // create chatroom ,send user to conversation screen, pushreplacement
  createChatroomAndStartConversation({String userName}) {
    print('${Constants.myName}');
    if(userName!=Constants.myName){
      String chatRoomId = getChatRoomId(Constants.myName,userName);
      List<String> users = [Constants.myName,userName];

      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomid": chatRoomId,
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ConversationScreen(
        chatRoomId: chatRoomId,
      )));
    }else{
      print("you cannot send message to yourself");
    }
  }

  Widget SearchTile({String userName, String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: mediumTextStyle(),
              ),
              Text(
                userEmail,
                style: mediumTextStyle(),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConversation(
                userName: userName
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Message",
                style: mediumTextStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }
  getUserInfo() async{
    _myName =await HelperFunctions.getUserNameSharedPreference();
    setState(() {

    });
    print('${_myName}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 50,
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.search,
        //       color: Colors.red,
        //     ),
        //     onPressed: () {
        //       print("your menu action here");
        //     },
        //   ),
        // ],

      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      style: TextStyle(color: Colors.white54),
                      decoration: InputDecoration(
                          hintText: "search username...",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      child: Image.asset("assets/images/search_white.png"),
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
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
