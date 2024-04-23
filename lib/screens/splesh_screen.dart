import 'package:flutter/material.dart';
import 'package:news_app/utility/color_code.dart';
import 'package:news_app/utility/local_database_function.dart';
import 'package:news_app/utility/string.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // after splash screen user navigate which screen home screen or login
    LocalStorage.userNavigate(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorCode.colorPrimary,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 80,
                width: 80,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(AppStrings.imageAppLogo),
              ),
              Text(
                AppStrings.strAppName,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
