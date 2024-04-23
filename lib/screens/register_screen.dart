import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app/database/db_helper.dart';
import 'package:news_app/model/user_details_model.dart';
import 'package:news_app/screens/login_screen.dart';
import 'package:news_app/utility/preferences.dart';
import 'package:news_app/utility/string.dart';
import 'package:news_app/utility/utilities.dart';
import 'package:news_app/widgets/text_form_filed_widget.dart';
import 'package:news_app/widgets/text_with_text_button_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController userNameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController mobileEditingController = TextEditingController();

  DBHelper userDBHelper = DBHelper();

  @override
  void dispose() {
    super.dispose();
    mobileEditingController.dispose();
    userNameEditingController.dispose();
    emailEditingController.dispose();
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
                hintText: AppStrings.hintUserName,
                labelText: AppStrings.labelUserName,
                icon: Icons.person,
                textEditingController: userNameEditingController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]'))
                ],
                maxLength: 50,
              ),
              const SizedBox(height: 10),
              TextFormFieldWidget(
                hintText: AppStrings.hintMobileNumber,
                labelText: AppStrings.labelMobileNumber,
                icon: Icons.phone,
                textEditingController: mobileEditingController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 10,
                isLengthSet: true,
              ),
              const SizedBox(height: 10),
              TextFormFieldWidget(
                hintText: AppStrings.hintEmailAddress,
                labelText: AppStrings.labelEmailAddress,
                icon: Icons.email,
                textEditingController: emailEditingController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                // inputFormatters: [
                //   FilteringTextInputFormatter.deny(
                //       RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'))
                //   /*
                //   * ^: Start of the string.
                //     [\w-\.]+: Matches one or more word characters (letters, digits, or underscore), hyphens, or periods.
                //     @: Matches the "@" symbol.
                //     ([\w-]+\.)+: Matches one or more groups of word characters followed by a period. This is for the domain name part.
                //     [\w-]{2,4}: Matches between 2 and 4 word characters. This is for the top-level domain (TLD) part (e.g., .com, .net).
                //     $: End of the string.
                //   * */
                // ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    userRegistration();
                  }
                },
                child: Text(
                  AppStrings.strRegister,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              TextWithTextButtonWidget(
                textMessage: AppStrings.strAlreadyHaveAccount,
                textButtonMessage: AppStrings.strLogin,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> userRegistration() async {
    await userDBHelper
        .addUserDetails(
      UserModel(
          userName: userNameEditingController.text.trim(),
          mobileNumber: mobileEditingController.text.trim(),
          email: emailEditingController.text.trim(),
          profileImage: ""),
    )
        .then((value) {
      // message for user to know register or not
      Utilities.showSnackBarMessage(
        context,
        value != 0
            ? AppStrings.successRegister
            : AppStrings.errorSomethingWrong,
      );

      // if register then navigate login screen
      if (value != 0) {
        Preferences.setString("User", "");
        Preferences.setString("MobileNumber", "");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }
}
