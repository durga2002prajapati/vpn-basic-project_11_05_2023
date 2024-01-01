import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/apis/apis.dart';
import 'package:vpn_basic_project/models/id_details.dart';
import 'package:vpn_basic_project/models/network_data.dart';
import 'package:vpn_basic_project/widgests/network_card.dart';

import '../main.dart';

class NetworkTestScreen extends StatelessWidget {
  const NetworkTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ipData = IPDetails.fromJson({}).obs;
    APIs.getIPDetails(ipData: ipData);

    return Scaffold(
      appBar: AppBar(title: Text('Network Test Screen')),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 10, right: 10),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            ipData.value = IPDetails.fromJson({});
            APIs.getIPDetails(ipData: ipData);
          },
          child: Icon(
            Icons.refresh_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(
        () => ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            left: mq.width * .04,
            right: mq.width * .04,
            bottom: mq.height * .015,
            top: mq.height * .01,
          ),
          children: [
            NetworkCard(
              data: NetworkData(
                  title: 'IP Address',
                  subtitle: ipData.value.query,
                  icon: Icon(
                    CupertinoIcons.location_solid,
                    color: Colors.blue,
                  )),
            ),
            NetworkCard(
              data: NetworkData(
                  title: 'Internet Provider',
                  subtitle: ipData.value.isp,
                  icon: Icon(
                    Icons.business,
                    color: Colors.orange,
                  )),
            ),
            NetworkCard(
              data: NetworkData(
                  title: 'Location',
                  subtitle: ipData.value.country.isEmpty
                      ? 'Fetching....'
                      : '${ipData.value.city}, ${ipData.value.regionName}, ${ipData.value.country}',
                  icon: Icon(
                    CupertinoIcons.location,
                    color: Colors.pink,
                  )),
            ),
            NetworkCard(
              data: NetworkData(
                  title: 'Pin-Code',
                  subtitle: ipData.value.zip,
                  icon: Icon(
                    CupertinoIcons.pin,
                    color: Colors.blue,
                  )),
            ),
            NetworkCard(
              data: NetworkData(
                  title: 'Timezone',
                  subtitle: ipData.value.timezone,
                  icon: Icon(
                    CupertinoIcons.timer_fill,
                    color: Colors.green,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
