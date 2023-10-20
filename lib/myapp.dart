import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interviewdemo/utils/app_string.dart';
import 'package:interviewdemo/utils/utils.dart';

import 'utils/navigation/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppString.appName,
          initialBinding: AppBidding(),
          initialRoute: Routes.splash,
          getPages: Routes.pages,
          builder: (context, child) {
            return Scaffold(
              body: GestureDetector(
                onTap: () {
                  Utils.hideKeyboardInApp(context);
                },
                child: child,
              ),
            );
          },
        );
  }
}

class AppBidding extends Bindings {
  @override
  void dependencies() {}
}
