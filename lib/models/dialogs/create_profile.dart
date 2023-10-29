import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trivia/colors/app_color.dart';
import 'package:trivia/data/box.dart';
import 'package:trivia/main.dart';
import 'package:trivia/models/dialogs/loading.dart';
import 'package:trivia/providers/profile.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'game.dart';

int? avatar;

showCreateProfileDialog(BuildContext context) {
  showGameDialog(
    context,
    isExitable: true,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
    margin: EdgeInsets.symmetric(horizontal: 40.w),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Choose an Avatar",
          style: TextStyle(
            color: AppColor.slightlyLighterYellow,
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        StatefulBuilder(builder: (context, setState) {
          return Wrap(
            runSpacing: 10.h,
            spacing: 10.w,
            children: List.generate(
              24,
              (index) => ZoomTapAnimation(
                onTap: () {
                  playTap(context);
                  setState(() {
                    avatar = index + 1;
                  });
                },
                child: Container(
                  width: 50.sp,
                  height: 50.sp,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/avatars/avatar_${index + 1}.png'),
                      colorFilter: avatar == null
                          ? null
                          : index + 1 == avatar
                              ? null
                              : const ColorFilter.mode(
                                  Colors.grey,
                                  BlendMode.saturation,
                                ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
        SizedBox(height: 20.h),
        ZoomTapAnimation(
          onTap: () {
            playTap(context);
            if (avatar != null) {
              Navigator.pop(context);
              showEnterUsernameDialog(context);
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
                      "Invalid Avatar",
                      style: TextStyle(
                        color: AppColor.slightlyLighterYellow,
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Please select an avatar to continue",
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
              "Next",
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

showEnterUsernameDialog(BuildContext context) {
  final controller = TextEditingController();

  showGameDialog(
    context,
    isExitable: true,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
    margin: EdgeInsets.symmetric(horizontal: 40.w),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Enter a Username",
          style: TextStyle(
            color: AppColor.slightlyLighterYellow,
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        StatefulBuilder(builder: (context, setState) {
          return Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  style: TextStyle(
                    color: AppColor.yellow,
                    fontSize: 18.sp,
                  ),
                  cursorColor: AppColor.slightlyLighterYellow,
                  onChanged: (value) {},
                  onSubmitted: (value) {
                    // playTap(context);
                    // if (controller.value.text.trim().isNotEmpty) {
                    //   final profileProvider = Provider.of<ProfileProvider>(
                    //       context,
                    //       listen: false);
                    //   profileProvider.createPlayer(
                    //     context,
                    //     username: controller.value.text.trim(),
                    //   );
                    //   Navigator.pop(context);
                    // } else {
                    //   showGameDialog(
                    //     context,
                    //     isExitable: true,
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 20, vertical: 40),
                    //     margin: EdgeInsets.symmetric(
                    //         horizontal: 60.w, vertical: 24.h),
                    //     child: Column(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         Text(
                    //           "Invalid Username",
                    //           style: TextStyle(
                    //             color: AppColor.slightlyLighterYellow,
                    //             fontSize: 25.sp,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //           textAlign: TextAlign.center,
                    //         ),
                    //         SizedBox(height: 10.h),
                    //         Text(
                    //           "Please provide a valid username to continue",
                    //           style: TextStyle(
                    //             color: AppColor.white,
                    //             fontSize: 18.sp,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //           textAlign: TextAlign.center,
                    //         ),
                    //         SizedBox(height: 30.h),
                    //         ZoomTapAnimation(
                    //           onTap: () {
                    //             playTap(context);
                    //             Navigator.pop(context);
                    //           },
                    //           child: Container(
                    //             padding: EdgeInsets.symmetric(
                    //               vertical: 10.sp,
                    //               horizontal: 20.sp,
                    //             ),
                    //             decoration: BoxDecoration(
                    //               color: Colors.white,
                    //               borderRadius: BorderRadius.circular(20.r),
                    //             ),
                    //             child: Text(
                    //               "Okay",
                    //               style: TextStyle(
                    //                 fontSize: 20.sp,
                    //               ),
                    //             ),
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   );
                    // }
                  },
                  textCapitalization: TextCapitalization.words,
                  // : TextCapitalization.none,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      borderSide: BorderSide(
                        color: AppColor.slightlyLighterYellow,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      borderSide: BorderSide(
                        color: AppColor.slightlyLighterYellow,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      borderSide: BorderSide(
                        color: AppColor.slightlyLighterYellow,
                      ),
                    ),
                    counterStyle: const TextStyle(
                      color: Colors.transparent,
                    ),
                  ),
                  maxLength: 10,
                ),
              ),
            ],
          );
        }),
        SizedBox(height: 20.h),
        ZoomTapAnimation(
          onTap: () {
            playTap(context);
            if (controller.value.text.trim().isNotEmpty) {
              box.put("avatar", avatar!);
              print("Avatar: $avatar");
              print("Username: ${controller.value.text.trim()}");
              final profileProvider =
                  Provider.of<ProfileProvider>(context, listen: false);
              profileProvider.addPlayer(
                context,
                username: controller.value.text.trim(),
                avatar: avatar!,
              );

              Navigator.pop(context);
              showLoadingDialog(context);

              profileProvider.addListener(() {
                if (!profileProvider.isLoading) {
                  Navigator.pop(context);
                }
              });
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
