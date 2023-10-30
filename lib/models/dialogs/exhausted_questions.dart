import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trivia/colors/app_color.dart';

import 'game.dart';

showExhaustedQuestionsDialog(BuildContext context) {
  showGameDialog(
    context,
    isExitable: true,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
    margin: EdgeInsets.symmetric(horizontal: 60.w, vertical: 24.h),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Oops!",
          style: TextStyle(
            color: AppColor.yellow,
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        Text(
          "You have exhausted the questions in this category. The previous questions will now be shown at random until you're done with all the levels.",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
