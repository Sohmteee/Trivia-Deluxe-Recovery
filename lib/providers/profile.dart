// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:trivia/colors/app_color.dart';
import 'package:trivia/data/box.dart';
import 'package:trivia/main.dart';
import 'package:trivia/models/dialogs/game.dart';
import 'package:trivia/providers/question.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class ProfileProvider extends ChangeNotifier {
  String? username = box.get("username", defaultValue: null);
  bool hasProfile = /* box.get("hasProfile", defaultValue:  */ false /* ) */;
  bool isLoading = false;

  createPlayer(BuildContext context,
      {required String username,
      required int avatar,
      required bool isCreatePlayer}) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String? deviceID = androidInfo.id;

    final questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);

    try {
      isLoading = true;
      final response = await http.post(
        Uri.parse("https://cbtportal.linkskool.com/api/post_score.php"),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Token $apiKey',
        },
        body: jsonEncode({
          'game_type': 'triviaDTest',
          'username': username,
          'avatar': avatar,
          'device_id': deviceID,
          'score': /* questionProvider.leaderboardScore.round() */ 20,
          'mode': 1,
        }),
      );

      box.put("id", deviceID);
      print("ID: $deviceID");

      Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == "success") {
        // Request was successful
        print(responseData);

        if (isCreatePlayer) {
          this.username = username;
          box.put("username", username);
          hasProfile = true;
          box.put("hasProfile", hasProfile);

          Future.delayed(.5.seconds, () {
            showGameDialog(
              context,
              isExitable: true,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              margin: EdgeInsets.symmetric(horizontal: 60.w, vertical: 24.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Profile Created Successfully",
                    style: TextStyle(
                      color: AppColor.yellow,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Your profile has been created successfully. Your can now view your progress on the leaderboard.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
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
          });
        }
      } else {
        // Request failed
        print('An error occured while creating profile');
        print(responseData);

        Future.delayed(.5.seconds, () {
          return showGameDialog(
            context,
            isExitable: true,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            margin: EdgeInsets.symmetric(horizontal: 60.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Profile Creation Failed",
                  style: TextStyle(
                    color: AppColor.yellow,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Text(
                  "Your profile could not be created. Please try again later.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
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
        });
      }
    } catch (e) {
      debugPrint('Exception: $e');
    } finally {
      isLoading = false;
    }

    notifyListeners();
  }
}
