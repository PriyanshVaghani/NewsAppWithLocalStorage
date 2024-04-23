import 'package:flutter/material.dart';
import 'package:news_app/model/user_details_model.dart';

class Utilities {
  static void showSnackBarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // store user details
  static UserModel? userModel;
}
