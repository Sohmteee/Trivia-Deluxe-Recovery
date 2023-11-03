import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trivia/colors/app_color.dart';
import 'package:trivia/main.dart';
import 'package:trivia/providers/money.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'game.dart';

bool showGameDialogPopDialog(BuildContext context) {
  showGameDialog(
    context,
    isExitable: true,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
    margin: EdgeInsets.symmetric(horizontal: 60.w, vertical: 24.h),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Where do you want to go? ",
          style: TextStyle(
            color: AppColor.yellow,
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30.h),
        ZoomTapAnimation(
          onTap: () {
            playTap(context);
            if (Provider.of<MoneyProvider>(context).coins >= 20) {
              Provider.of<MoneyProvider>(context).decreaseCoins(20);
            }
            Navigator.pushReplacementNamed(context, "/stage");
            return true;
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 10.sp,
              horizontal: 35.sp,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              "Stage",
              style: TextStyle(
                fontSize: 20.sp,
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        ZoomTapAnimation(
          onTap: () {
            playTap(context);
            if (Provider.of<MoneyProvider>(context).coins >= 20) {
              Provider.of<MoneyProvider>(context).decreaseCoins(20);
            }
            Navigator.pushReplacementNamed(context, "/select");
            return true;
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 10.sp,
              horizontal: 20.sp,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              "Categories",
              style: TextStyle(
                fontSize: 20.sp,
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        ZoomTapAnimation(
          onTap: () {
            playTap(context);
            if (Provider.of<MoneyProvider>(context).coins >= 20) {
              Provider.of<MoneyProvider>(context).decreaseCoins(20);
            }
            Navigator.pushReplacementNamed(context, "/menu");
            return true;
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 10.sp,
              horizontal: 20.sp,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              "Main Menu",
              style: TextStyle(
                fontSize: 20.sp,
              ),
            ),
          ),
        ),
        SizedBox(height: 30.h),
        Text(
          "20 coins will still be deducted from you if you have up to that.",
          style: TextStyle(
            fontSize: 20.sp,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  return false;
}
