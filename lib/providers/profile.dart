import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'package:trivia/data/box.dart';

class ProfileProvider extends ChangeNotifier {
  String? username = box.get("username", defaultValue: null);
  String? gender = box.get("gender", defaultValue: null);
  bool hasProfile = box.get("hasProfile", defaultValue: false);

  createPlayer(BuildContext context,
      {required String username,  required int avatar}) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String? deviceID = androidInfo.id;

    final questionProvider = Provider.of<QuestionProvider>(context, listen: false);

    try {
      final response = await http.post(
        Uri.parse("cbtportal.linkskool.com/api/post_score.php"),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Token $apiKey',
        },
        body: jsonEncode({
          'game_type': 'triviaDeluxe',
          'username': username,
          'avatar': avatar,
          'device_id': deviceID,
          'score': quesi,
          'mode': password,
        }),
      );

      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData.containsKey("profile")) {
        // Map<String, dynamic> profile = responseData['profile'];
        return "Sign up successful";
      } else {
        return responseData['username'][0].toString();
      }
    } catch (e) {
      debugPrint('Exception: $e');
      Navigator.pop(context);
      return '$e';
    }

    this.username = username;
    hasProfile = true;

    ToastContext().init(context);
    Toast.show(
      "Profile created successfully",
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: 20.sp,
      ),
      duration: Toast.lengthLong,
      gravity: Toast.center,
    );

    notifyListeners();
  }
}
