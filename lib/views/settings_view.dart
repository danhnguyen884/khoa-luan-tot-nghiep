import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/views/smal_screen.dart';
import 'package:chat_app/views/update_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).appBarTheme.color;
    AuthMethods authMethods = new AuthMethods();
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left: 0.0,top: 0.0),

          child: Text(
            'Settings',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              // AvatarImageView(
              //   //TODO: implement change avatar
              //   onTap: () => null,
              //   child: image != null
              //       ? Image.network(
              //     image,
              //     fit: BoxFit.cover,
              //   )
              //       : Icon(
              //     Icons.person_outline,
              //     size: 100,
              //     color: Colors.grey[400],
              //   ),
              // ),
              Text(
                Constants.myName,
                style: TextStyle(
                  fontSize: 24,
                  color: textColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.nights_stay_outlined),
                  const SizedBox(width: 10),
                  Text(
                    'Dark Mode',
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),
                  Spacer(),
                  CupertinoSwitch(
                    value: _switchValue,
                    onChanged: (value) {
                      _switchValue = value;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Builder(builder: (context) {
                return GestureDetector(
                  onTap: () {
                    return Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UpdateUser()));
                  },
                  child: Row(children: [
                    Icon(Icons.settings),
                    const SizedBox(width: 10),
                    Text(
                      'Account Settings',
                      style: TextStyle(
                        color: textColor,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_right),
                  ]),
                );
              }),
              const SizedBox(height: 15),
              Builder(builder: (context) {
                return GestureDetector(
                  onTap: () {
                    authMethods.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: Row(children: [
                    Icon(Icons.logout),
                    const SizedBox(width: 10),
                    Text(
                      'Logout',
                      style: TextStyle(
                        color: textColor,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_right),
                  ]),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
