import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_app/model/user_details_model.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/screens/login_screen.dart';
import 'package:news_app/utility/preferences.dart';
import 'package:news_app/utility/utilities.dart';

class LocalStorage {
  // for get user details from local storage
  static Future<void> getUserDetailsFromLocalStorage() async {
    String userDetails = await Preferences.getString("User");
    if (userDetails.isNotEmpty) {
      Utilities.userModel = UserModel.fromJson(jsonDecode(userDetails));
    }
  }

  // for store user details into local storage
  static Future<void> addUserDetailsFromLocalStorage() async {
    await Preferences.setString(
        "User", jsonEncode(Utilities.userModel!.toJson()));
  }

  // if user set remember me then it navigate to home screen
  static Future<void> userNavigate(BuildContext context) async {
    bool isLogin = await Preferences.getBool("isLogin");
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              isLogin ? const HomeScreen() : const LoginScreen(),
        ),
      );
    });
  }
}
