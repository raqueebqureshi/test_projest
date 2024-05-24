

import 'dart:convert';

import 'package:test_project/services/api_client.dart';

import 'dart:async';

class Api{



  static Future<dynamic> getMarketData() async {
    var status;
    dynamic res = await ApiClient.getMethod();
    // print("response API $res");
    if(status!=401){
    if (res!={}) {
      try {
        return jsonDecode(res);
      } catch (e) {
        print(e);
      }
    }}else{
      print("Error occurred, Please check the request");
    }
    return res;
  }







}