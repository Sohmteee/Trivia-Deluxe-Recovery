import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trivia/colors/app_color.dart';
import 'package:trivia/main.dart';
import 'package:trivia/providers/profile.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'game.dart';

showCreateProfileDialog(BuildContext context) {
  final controller = TextEditingController();
  bool isMale = true;


  showGameDialog(
    context,
    isExitable: true,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
    margin: EdgeInsets.symmetric(horizontal: 40.w),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Create Profile",
          style: TextStyle(
            color: AppColor.slightlyLighterYellow,
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        Column(
          children: [
            Text(
              "Gender",
              style: TextStyle(
                color: AppColor.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            StatefulBuilder(builder: (context, setState) {
              return Wrap(
                children: List,
              );
            }),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                // autofocus: true,
                style: TextStyle(
                  color: AppColor.yellow,
                  fontSize: 18.sp,
                ),
                onChanged: (value) {},
                onSubmitted: (value) {
                  playTap(context);
                  if (controller.value.text.trim().isNotEmpty) {
                    final profileProvider =
                        Provider.of<ProfileProvider>(context, listen: false);
                    profileProvider.createPlayer(
                      context,
                      username: controller.value.text.trim(),
                    );
                    Navigator.pop(context);
                  } else {
                    showGameDialog(
                      context,
                      isExitable: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      margin: EdgeInsets.symmetric(
                          horizontal: 60.w, vertical: 24.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Invalid Username",
                            style: TextStyle(
                              color: AppColor.slightlyLighterYellow,
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "Please provide a valid username to continue",
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 30.h),
                          ZoomTapAnimation(
                            onTap: () {
                              playTap(context);
                              Navigator.pop(context);
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
                                "Okay",
                                style: TextStyle(
                                  fontSize: 20.sp,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
                textCapitalization: TextCapitalization.words,
                // : TextCapitalization.none,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "Username (Tap to edit)",
                  labelStyle: TextStyle(
                    color: AppColor.white,
                    fontSize: 22.sp,
                  ),
                  border: InputBorder.none,
                  counterStyle: const TextStyle(
                    color: Colors.transparent,
                  ),
                ),
                maxLength: 10,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        ZoomTapAnimation(
          onTap: () {
            playTap(context);
            if (controller.value.text.trim().isNotEmpty) {
              final profileProvider =
                  Provider.of<ProfileProvider>(context, listen: false);
              profileProvider.createPlayer(
                context,
                username: controller.value.text.trim(),
              );
              Navigator.pop(context);
            } else {
              showGameDialog(
                context,
                isExitable: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                margin: EdgeInsets.symmetric(horizontal: 60.w, vertical: 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Invalid Username",
                      style: TextStyle(
                        color: AppColor.slightlyLighterYellow,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Please provide a valid username to continue",
                      style: TextStyle(
                        color: AppColor.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30.h),
                    ZoomTapAnimation(
                      onTap: () {
                        playTap(context);
                        Navigator.pop(context);
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
                          "Okay",
                          style: TextStyle(
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
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
              "Create",
              style: TextStyle(
                fontSize: 20.sp,
              ),
            ),
          ),
        )
      ],
    ),
  );
}
