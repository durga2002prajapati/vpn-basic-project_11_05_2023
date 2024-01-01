import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/screens/home_screen.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // for the purpose of splash screen
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      // exit full screen

      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      // navigate to home
      Get.off(() => HomeScreen());

      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (_) => HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              left: mq.width * .3,
              top: mq.height * .2,
              width: mq.width * .4,
              child: Image.asset('assets/image/ttvpn.png')),
          Positioned(
              bottom: mq.height * .15,
              width: mq.width,
              child: Text(
                '🇳🇵\nWelcome To TikTok assistant ️ ❣️',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).lightText,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 25),
              ))
        ],
      ),
    );
  }
}
