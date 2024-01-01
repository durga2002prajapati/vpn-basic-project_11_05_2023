import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helper/pref.dart';
import '../models/vpn.dart';
import '../models/vpn_config.dart';
import '../services/vpn_engine.dart';

class HomeController extends GetxController {
  final Rx<Vpn?> vpn = Pref.vpn.obs;

  final vpnState = VpnEngine.vpnDisconnected.obs;

  void connectToVpn() {
    if (vpn.value!.openVPNConfigDataBase64.isEmpty) return;

    if (vpnState.value == VpnEngine.vpnDisconnected) {
      final data = Base64Decoder().convert(vpn.value!.openVPNConfigDataBase64);

      // log('\n Before: ${vpn.value!.openVPNConfigDataBase64}' as num);

      final config = Utf8Decoder().convert(data);
      final vpnConfig = VpnConfig(
          country: vpn.value!.countryLong,
          username: 'vpn',
          password: 'vpn',
          config: config);

      // log('\n After: ${config}' as num);

      ///Start if stage is disconnected
      VpnEngine.startVpn(vpnConfig);
    } else {
      ///Stop if stage is "not" disconnected

      VpnEngine.stopVpn();
    }
  }

  // vpn button color
  Color get getButtonColor {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return Colors.blue;

      case VpnEngine.vpnConnected:
        return Colors.green;

      default:
        return Colors.orange;
    }
  }

  // vpn button text
  String get getButtonText {
    switch (vpnState.value) {
      case VpnEngine.vpnDisconnected:
        return 'Tap to connect';

      case VpnEngine.vpnConnected:
        return 'Disconnected';

      default:
        return 'Connecting';
    }
  }
}
