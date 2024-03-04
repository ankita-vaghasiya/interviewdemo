import 'package:flutter/material.dart';
import 'package:interviewdemo/utils/navigation/routes.dart';

import 'utils/navigation/navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    FireBaseNotification().firebaseCloudMessagingLSetup();
    Future.delayed(const Duration(seconds: 3), () {
      navigateFurther(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      key: ValueKey("Container"),
      width: double.maxFinite,
      child: Center(
        child: Text(
          'Splash screen ',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Future<void> navigateFurther(BuildContext context) async {
    Navigation.replace(Routes.splash);
  }
}