import 'package:chat_app/animation/FadeAnimation.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatRoomsScreen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp({this.toggle});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =
  new TextEditingController();
  TextEditingController emailTextEditingController =
  new TextEditingController();
  TextEditingController passwordTextEditingController =
  new TextEditingController();
  AnimationController controller;

  signMeUp() {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        "name": userNameTextEditingController.text,
        "email": emailTextEditingController.text,
        "imageUrl" : null,
        "intro" : null,
        "userId": null
      };

      HelperFunctions.saveUserNameSharedPreference(
          userNameTextEditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);
      setState(() {
        isLoading = true;
      });

      authMethods.signUpWithEmailAndPassword(
          emailTextEditingController.text, passwordTextEditingController.text)
          .then((val) {
        print("${val.uid}");

        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);

        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ChatRoom()
        ));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  isLoading? Container(
                   child: Center(child: CircularProgressIndicator()),
                 ):SingleChildScrollView(
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background/background.png"),
                  fit: BoxFit.cover
              )
          ),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 25, top: 40),
                        child: IconButton(
                            iconSize: 30,
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              return Navigator.pop(context);
                            }
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(left: 40),
                                  child: Text(
                                    "Hello,",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25
                                    ),
                                  )
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 40),
                                  child: Text(
                                    "Stacy",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 38,
                                        fontWeight: FontWeight.w500
                                    ),
                                  )
                              ),
                            ],
                          ),
                          FadeAnimation(1.6, Container(
                            padding: EdgeInsets.only(left: 20, top: 30),
                            child: Image(
                              image: AssetImage(
                                  "assets/ilustration/ilustration2.png"),
                              height: 250,
                              width: 250,
                            ),
                          ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Container(
                              width: 330,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      "Username",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xffFE5A3F)
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: userNameTextEditingController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                        fontSize: 20
                                    ),
                                    decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffFE5A3F)
                                            )
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Color(0xffFE5A3F),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 330,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      "Email",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xffFE5A3F)
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: emailTextEditingController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                        fontSize: 20
                                    ),
                                    decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffFE5A3F)
                                            )
                                        ),
                                        prefixIcon: Icon(
                                          Icons.mail,
                                          color: Color(0xffFE5A3F),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            Container(
                              width: 330,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                      "Password",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xffFE5A3F)
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: passwordTextEditingController,
                                    obscureText: true,
                                    style: TextStyle(
                                        fontSize: 20
                                    ),
                                    decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffFE5A3F)
                                          ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.vpn_key,
                                          color: Color(0xffFE5A3F),
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 30,
                        child: RaisedButton(
                          onPressed: () {
                            signMeUp();
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)
                          ),
                          padding: EdgeInsets.all(0),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xffFE5A3F),
                                  Color(0xffE67332)
                                ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: 260.0, minHeight: 60.0),
                              alignment: Alignment.center,
                              child: Text(
                                "Sign Up",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 50,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (val) {
                                return val.isEmpty || val.length < 2
                                    ? "Please Provide a valid UserName"
                                    : null;
                              },
                              controller: userNameTextEditingController,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("username"),
                            ),
                            TextFormField(
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "Please provide a valid emailid";
                              },
                              controller: emailTextEditingController,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("email"),
                            ),
                            TextFormField(
                              obscureText: true,
                              validator: (val) {
                                return val.length > 6
                                    ? null
                                    : "Please provide password 6+ character";
                              },
                              controller: passwordTextEditingController,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("password"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            'Forgot Password?',
                            style: simpleTextStyle(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          signMeUp();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                const Color(0xff007EF4),
                                const Color(0xff2A75BC)
                              ]),
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            'Sign Up',
                            style: mediumTextStyle(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          'SignUp With Google',
                          style: TextStyle(color: Colors.black87, fontSize: 17),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have account?",
                            style: mediumTextStyle(),
                          ),
                          GestureDetector(
                            onTap: (){
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "SignIn now",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

