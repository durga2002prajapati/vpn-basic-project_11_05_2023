import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/controllers/home_controller.dart';
import 'package:vpn_basic_project/helper/pref.dart';
import 'package:vpn_basic_project/screens/location_screen.dart';
import 'package:vpn_basic_project/screens/network_test_screen.dart';
import 'package:vpn_basic_project/widgests/count_down_timer.dart';
import 'package:vpn_basic_project/widgests/home_card.dart';
import '../main.dart';
import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';

class HomeScreen extends StatelessWidget {
  final _controller = Get.put(HomeController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ///Add listener to update vpn state
    VpnEngine.vpnStageSnapshot().listen((event) {
      _controller.vpnState.value = event;
    });
    return Scaffold(
      appBar: AppBar(
        leading: Icon(CupertinoIcons.home),
        title: Text('TikTok Vpn'),
        actions: [
          IconButton(
              onPressed: () {
                Get.changeThemeMode(
                    Pref.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                Pref.isDarkMode = !Pref.isDarkMode;
              },
              icon: Icon(
                Icons.brightness_6_outlined,
                size: 27,
              )),
          IconButton(
              padding: EdgeInsets.only(right: 8),
              onPressed: () => Get.to(() => NetworkTestScreen()),
              icon: Icon(
                Icons.info_outline,
                size: 27,
              )),
        ],
      ),

      bottomNavigationBar: _changeLocation(context),

      //body

      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        //for adding some space

        // vpn Button
        Obx(() => _vpnButton()),

        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomeCard(
                  title: _controller.vpn.value == null
                      ? 'Country'
                      : _controller.vpn.value!.countryLong,
                  subtitle: 'FREE',
                  icon: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child: _controller.vpn.value == null
                        ? Icon(Icons.vpn_lock_rounded,
                            size: 30, color: Colors.white)
                        : null,
                    backgroundImage: _controller.vpn.value!.countryLong.isEmpty
                        ? null
                        : AssetImage(
                            ('assets/flags/${_controller.vpn.value!.countryShort.toLowerCase()}.png'),
                          ),
                  )),
              HomeCard(
                  title: _controller.vpn.value == null
                      ? '100 ms'
                      : _controller.vpn.value!.ping + 'ms',
                  subtitle: 'PING',
                  icon: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.orangeAccent,
                    child: Icon(
                      Icons.equalizer_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),

        StreamBuilder<VpnStatus?>(
            initialData: VpnStatus(),
            stream: VpnEngine.vpnStatusSnapshot(),
            builder: (context, snapshot) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HomeCard(
                        title: "${snapshot.data?.byteIn ?? '0 kbps'}",
                        subtitle: 'DOWNLOAD',
                        icon: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.lightGreen,
                          child: Icon(
                            Icons.download,
                            size: 30,
                            color: Colors.white,
                          ),
                        )),
                    HomeCard(
                        title: "${snapshot.data?.byteOut ?? '0 kbps'}",
                        subtitle: 'UPLOAD',
                        icon: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blueGrey,
                          child: Icon(
                            Icons.upload,
                            size: 30,
                            color: Colors.white,
                          ),
                        )),
                  ],
                )),
      ]),
    );
  }

  // for the purpose of vpn button
  Widget _vpnButton() => Column(
        children: [
          //button
          Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                _controller.connectToVpn();
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _controller.getButtonColor.withOpacity(.1),
                ),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _controller.getButtonColor.withOpacity(.3),
                  ),
                  child: Container(
                    width: mq.height * .14,
                    height: mq.height * .14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _controller.getButtonColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.power_settings_new_rounded,
                          size: 28,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 5,
                        ),

                        // for Text
                        Text(
                          _controller.getButtonText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          //connection status label
          Container(
            margin:
                EdgeInsets.only(top: mq.height * .015, bottom: mq.height * .02),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(15)),
            child: Text(
              _controller.vpnState == VpnEngine.vpnDisconnected
                  ? 'Disconnect'
                  : _controller.vpnState.replaceAll('_', ' ').toUpperCase(),
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),

          //count down timer
          Obx(() => CountDownTimer(
              startTimer:
                  _controller.vpnState.value == VpnEngine.vpnConnected)),
        ],
      );

  Widget _changeLocation(BuildContext context) => SafeArea(
        child: Semantics(
          button: true,
          child: InkWell(
            onTap: () => Get.to(() => LocationScreen()),
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
                color: Theme.of(context).bottomNav,
                height: 60,
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.globe,
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),

                    // for Text
                    Text(
                      'Change Location',
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    // for covering available space
                    Spacer(),

                    //for icon
                    CircleAvatar(
                      child: Icon(
                        CupertinoIcons.arrow_right,
                        color: Colors.blue,
                        size: 28,
                      ),
                    ),
                  ],
                )),
          ),
        ),
      );
}
