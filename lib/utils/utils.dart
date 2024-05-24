
// ignore_for_file: prefer_const_constructors




import 'package:flutter/material.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

class Utils{



  static const Color appThemeColor = Color(0xff0373c6);

  static showLoader1() {
    return Container(
      width: double.infinity,
      color: Colors.black12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: const [
          SizedBox(
            width: 40,
            height: 40,
            child:  CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(appThemeColor),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text("Loading...",
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w600
            ),
          )
        ],
      )
    );
  }

  static Future<void> showPopDialog(
      BuildContext context, {
        required title, required buttonText, Function()? posFunction, Function()? negFunction,}) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              child: StatefulBuilder(
                  builder: (c, state) => Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              height: 1.2,
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          thickness: 1,
                          color: Color(0xffCDCDCD),
                          height: 0,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                             Navigator.pop(context);
                             negFunction!();

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: appThemeColor,
                            ),
                            child: Text(
                              buttonText,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            );
          });
        });
  }




  static Future<void> checkWifiSecurity(context) async {
    final WifiInfo wifiInfo = WifiInfo();

    try {
      // print('wifiInfo ${wifiInfo.getLocationServiceAuthorization()}');
      String? ssid = await wifiInfo.getWifiName();
      String? bssid = await wifiInfo.getWifiBSSID();
      String? ip = await wifiInfo.getWifiIP();
      String? security = await getWifiSecurity(); //dummy

      if (ssid != null && bssid != null && ip != null) {
        print('Connected to SSID: $ssid');
        print('BSSID: $bssid');
        print('IP Address: $ip');
        print('Security: $security');
        showToast("Connected to SSID: $ssid and the network is $security",);

      } else {
        print('No Wi-Fi connection detected.');
      }
    } catch (e) {
      print('Failed to get Wi-Fi info: $e');
    }
  }

  static Future<String> getWifiSecurity() async {

    // dummy data
    return Future.value('Secure (WPA2)');
  }

  static void checkWifi(context) {
    checkWifiSecurity(context);
  }



  static showToast( String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static showSnackBar(context, String msg, {dur}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        style: TextStyle(fontSize: 15),
      ),
      duration: Duration(milliseconds: dur ?? 1000),
      elevation: 2,

      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
    ));
  }




}