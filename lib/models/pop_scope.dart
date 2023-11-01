import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import 'package:trivia/colors/app_color.dart';
import 'package:trivia/main.dart';

Future<bool> onWillPop(context, isExitable) async {
  if (isExitable) {
    return true;
  }
  playUnavailable(context);
  ToastContext().init(context);
  Toast.show(
    "You can't go back at the moment",
    duration: 2,
    gravity: Toast.bottom,
    backgroundColor: AppColor.slightlyLighterYellow,
    textStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.sp,
    ),
  );
  return false;
}
