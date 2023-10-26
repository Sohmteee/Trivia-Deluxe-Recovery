import 'package:flutter/material.dart';
import 'package:trivia/data/box.dart';

class ProfileProvider extends ChangeNotifier {
  String? username = box.get("username", defaultValue: null);
  String? gender = box.get("gender", defaultValue: null);
  bool hasProfile = box.get("hasProfile", defaultValue: false);

  createPlayer({required String username, required bool isMale}) {
    /* DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String? deviceID = androidInfo.id; */

    hasProfile = true;
    notifyListeners();
  }
}
