import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:interviewdemo/utils/app_string.dart';
import 'package:interviewdemo/utils/utils.dart';

import 'utils/navigation/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          locale: LanguageChangeProvider.currentLocal,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
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
