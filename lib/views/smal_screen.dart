import 'package:chat_app/animation/FadeAnimation.dart';
import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/views/signin.dart';
import 'package:chat_app/views/signup.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final Function toggle;
  HomeScreen({this.toggle});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {



  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: <Color>[
                Color(0xffFE5A3F),
                Color(0xffE67332)
              ],
            )
        ),
        child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 40,top: 50),
                  child: Image(
                    image: AssetImage("assets/icons/a.png"),
                    height: 70,
                    width: 70,
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 40,top: 30),
                        child: Text(
                          "Hello,",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        )
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.only(left: 40,top: 60),
                        child: Text(
                          "Stacy",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.w500
                          ),
                        )
                    ),
                    FadeAnimation(2.5,Container(
                      height: MediaQuery.of(context).size.height/3,
                      padding: EdgeInsets.only(left: 120,top: 50),
                      child: Image(
                        image: AssetImage("assets/ilustration/ilustration1.png"),
                        height: 320,
                        width: 320,
                      ),
                    ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 160,
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: 260,
                        child: MaterialButton(
                          onPressed: (){
                            return Navigator.push(context, MaterialPageRoute(
                                builder: (_) => SignUp()
                            ));
                            widget.toggle();
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                  color: Colors.white,
                                  width: 2
                              )
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 40,
                        width: 260,
                        child: MaterialButton(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                  color: Colors.white,
                                  width: 2
                              )
                          ),
                          onPressed: (){
                            return Navigator.push(context, MaterialPageRoute(
                                builder: (_) => Authenticate()
                            ));
                          },
                          child:Text(
                            "Sign In",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xffFE5A3F),
                                fontSize: 18
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              letterSpacing: 1,
                              decoration: TextDecoration.underline
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
        )
    );
  }
}