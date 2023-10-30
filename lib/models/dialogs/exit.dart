import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trivia/main.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'game.dart';

showExitDialog(BuildContext context) {
  showGameDialog(
    context,
    isExitable: true,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Are you sure you want to exit?",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 40.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ZoomTapAnimation(
              onTap: () {
                playTap(context);
                SystemNavigator.pop();
                return true;
              },
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  "Yeah",
                  style: TextStyle(
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
            ZoomTapAnimation(
              onTap: () {
                playTap(context);
                Navigator.pop(context);
                return false;
              },
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  "Nah",
                  style: TextStyle(
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
