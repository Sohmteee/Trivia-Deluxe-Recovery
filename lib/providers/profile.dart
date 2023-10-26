import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:trivia/data/box.dart';

class ProfileProvider extends ChangeNotifier {
  String? username = box.get("username", defaultValue: null);
  String? gender = box.get("gender", defaultValue: null);

  createPlayer() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String? deviceID = androidInfo.id;

    print()
  }
}
