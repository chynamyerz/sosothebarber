/*
*  general_util.dart
*  GeneralUtil
*
*  Created by QOS-Software Solutions Team.
*  Copyright © 2018 QOS-Software Solutions (Pty, Ltd). All rights reserved.
*/

import 'package:shared_preferences/shared_preferences.dart';

class AuthUtil {
  Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    return token;
  }

  Future<void> setUser(String user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user);
  }

  Future<String> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user');

    return user;
  }
}