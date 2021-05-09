import 'dart:math';

import 'package:chat_app/modul/call.dart';
import 'package:chat_app/modul/user.dart';
import 'package:chat_app/services/call_methods.dart';
import 'package:chat_app/views/callscreens/call_screen.dart';
import 'package:flutter/material.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({UserData from, UserData to, context}) async {
    Call call = Call(
      callerId: from.name,
      receiverId: to.name,
      channelId: Random().nextInt(1000).toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(call: call),
          ));
    }
  }
}