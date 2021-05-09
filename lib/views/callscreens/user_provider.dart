import 'package:chat_app/modul/user.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserData _user;
  DatabaseMethods _databaseMethods = DatabaseMethods();

  UserData get getUser => _user;

  void refreshUser() async {
    UserData user = await _databaseMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

}