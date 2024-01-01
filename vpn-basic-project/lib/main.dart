import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:vpn_basic_project/screens/splash_screen.dart';

import 'helper/pref.dart';

// global object for accessing device screen size
late Size mq;

// for the purpose of portrait screen only not landscape screen
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  await Pref.initializeHive();

  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    runApp(const MyApp(
    )
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TikTok Vpn',
      home: SplashScreen(),




      // for the purpose of theme
      theme:
          ThemeData(appBarTheme: AppBarTheme(centerTitle: true, elevation: 2),),

      themeMode: Pref.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      darkTheme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: AppBarTheme(centerTitle: true, elevation: 2)),
    );
  }
}

extension AppTheme on ThemeData {
  Color get lightText => Pref.isDarkMode ? Colors.white : Colors.black54;

  Color get bottomNav => Pref.isDarkMode ? Colors.white12 : Colors.teal;
}
