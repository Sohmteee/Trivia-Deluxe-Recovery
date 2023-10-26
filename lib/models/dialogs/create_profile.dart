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
    // margin: EdgeInsets.symmetric(horizontal: 60.w, vertical: 24.h),

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
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      ZoomTapAnimation(
                        onTap: () {
                          playTap(context);
                          setState(() {
                            isMale = true;
                          });
                        },
                        child: Container(
                          width: 60.sp,
                          height: 60.sp,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: const AssetImage('assets/images/man.png'),
                              colorFilter: isMale
                                  ? null
                                  : const ColorFilter.mode(
                                      Colors.grey,
                                      BlendMode.saturation,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Male",
                        style: TextStyle(
                          color: isMale ? Colors.greenAccent : Colors.grey[300],
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ZoomTapAnimation(
                        onTap: () {
                          playTap(context);
                          setState(() {
                            isMale = false;
                          });
                        },
                        child: Container(
                          width: 60.sp,
                          height: 60.sp,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image:
                                  const AssetImage('assets/images/woman.png'),
                              colorFilter: isMale
                                  ? const ColorFilter.mode(
                                      Colors.grey,
                                      BlendMode.saturation,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Female",
                        style: TextStyle(
                          color: !isMale
                              ? AppColor.slightlyLighterYellow
                              : Colors.grey[300],
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
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
                style: TextStyle(
                  color: AppColor.yellow,
                  fontSize: 18.sp,
                ),
                onChanged: (value) {},
                // onSubmitted: widget.onSubmitted,
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
            if (controller.value.text.isNotEmpty) {
              final profileProvider = Provider.of<ProfileProvider>(context,
                  listen: false);
                  
              Navigator.pop(context);
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
