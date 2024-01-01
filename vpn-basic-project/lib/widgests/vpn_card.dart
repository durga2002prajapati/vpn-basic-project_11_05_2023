import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/controllers/home_controller.dart';
import 'package:vpn_basic_project/helper/pref.dart';
import 'package:vpn_basic_project/services/vpn_engine.dart';
import '../main.dart';
import '../models/vpn.dart';

class VpnCard extends StatelessWidget {
  final Vpn vpn;

  const VpnCard({super.key, required this.vpn});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: mq.height * .01),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          controller.vpn.value = vpn;
          Pref.vpn = vpn;
          Get.back();

          if (controller.vpnState.value == VpnEngine.vpnConnected) {
            VpnEngine.stopVpn();
            Future.delayed(
                Duration(seconds: 2), () => controller.connectToVpn());
          } else {
            controller.connectToVpn();
          }
        },
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

          leading: Container(
            padding: EdgeInsets.all(.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black54),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                  'assets/flags/${vpn.countryShort.toLowerCase()}.png',
                  height: 40,
                  width: mq.width * .15,
                  fit: BoxFit.cover),
            ),
          ),

          //for title
          title: Text(vpn.countryLong),

          //for subtitle
          subtitle: Row(
            children: [
              Icon(Icons.speed_sharp, color: Colors.blue, size: 20),
              SizedBox(width: 4),
              Text(
                _formatBytes(vpn.speed, 1),
                style: TextStyle(fontSize: 13),
              )
            ],
          ),

          // for trailing
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(vpn.numVpnSessions.toString(),
                  style: TextStyle(
                      fontSize: 13, color: Theme.of(context).lightText)),
              SizedBox(width: 4),
              Icon(Icons.person_3_sharp, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }

  String _formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    var suffixes = ['Bps', 'Kbps', 'mbps', 'Gbps', 'Tbps'];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
