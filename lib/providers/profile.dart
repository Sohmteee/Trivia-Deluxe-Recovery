import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:trivia/data/box.dart';

class ProfileProvider extends ChangeNotifier{
  String? username = box.get("username", defaultValue: null);
  String? gender = box.get("gender", defaultValue: null);

  createPlayer() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
String deviceID = await deviceInfo.androidInfo;
  }
}