

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FireBaseNotification().configureSelectNotificationSubject();
  await FireBaseNotification().setUpLocalNotification();
  FireBaseCrashlyticsUtils().init();
  await AppPreference.initMySharedPreferences();
  if (AppPreference.getLang().isEmpty) AppPreference.setLang('en');
  LanguageChangeProvider();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}