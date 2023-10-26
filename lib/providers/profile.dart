import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import 'package:trivia/data/box.dart';

class ProfileProvider extends ChangeNotifier {
  String? username = box.get("username", defaultValue: null);
  String? gender = box.get("gender", defaultValue: null);
  bool hasProfile = box.get("hasProfile", defaultValue: false);

  createPlayer(BuildContext context,
      {required String username, required bool isMale,  int? avatar}) {
    /* DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String? deviceID = androidInfo.id; */

    this.username = username;
    gender = isMale ? "m" : "f";
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
