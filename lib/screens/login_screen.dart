import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/database/db_helper.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/screens/register_screen.dart';
import 'package:news_app/utility/preferences.dart';
import 'package:news_app/utility/string.dart';
import 'package:news_app/utility/utilities.dart';
import 'package:news_app/widgets/text_form_filed_widget.dart';
import 'package:news_app/widgets/text_with_text_button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController mobileEditingController = TextEditingController();
  bool isRememberMe = false;

  DBHelper userDBHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    _loadUserMobileNumber();
  }

  @override
  void dispose() {
    super.dispose();
    mobileEditingController.dispose();
  }

  // this for get the mobile number from local storage if user select remember me
  Future<void> _loadUserMobileNumber() async {
    mobileEditingController.text = await Preferences.getString('MobileNumber');
    setState(() {
      isRememberMe = mobileEditingController.text.isNotEmpty;
    });
  }

  // this for save the mobile number in local storage
  Future<void> _saveUserMobileNumber() async {
    await Preferences.setString(
        'MobileNumber', mobileEditingController.text.trim());
    await Preferences.setString(
        'User', jsonEncode(Utilities.userModel!.toJson()));
    await Preferences.setBool('isLogin', true);
  }

  Future<void> _removeDataFromDataBase() async {
    await Preferences.setBool('isLogin', false);
    await Preferences.setString('MobileNumber', "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormFieldWidget(
                hintText: AppStrings.hintMobileNumber,
                labelText: AppStrings.labelMobileNumber,
                icon: Icons.phone,
                textEditingController: mobileEditingController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 10,
                isLengthSet: true,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Checkbox(
                    value: isRememberMe,
                    onChanged: (value) {
                      setState(() {
                        isRememberMe = value!;
                      });
                    },
                  ),
                  Text(AppStrings.strRememberMe),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  userLogin();
                },
                child: Text(
                  AppStrings.strLogin,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              TextWithTextButtonWidget(
                textMessage: AppStrings.strDoNotHaveAccount,
                textButtonMessage: AppStrings.strRegister,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void userLogin() {
    if (formKey.currentState!.validate()) {
      userDBHelper
          .getUserDetails(mobileEditingController.text.trim())
          .then((value) {
        // message for user to know login or not
        Utilities.showSnackBarMessage(
          context,
          value ? AppStrings.successLogin : AppStrings.errorSomethingWrong,
        );
        // if login then navigate home screen
        if (value) {
          if (isRememberMe) {
            _saveUserMobileNumber();
          } else {
            _removeDataFromDataBase();
          }
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      });
    }
  }
}
