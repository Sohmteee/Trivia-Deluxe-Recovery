import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trivia/colors/app_color.dart';
import 'package:trivia/main.dart';
import 'package:trivia/models/dialogs/create_profile.dart';
import 'package:trivia/models/game_background.dart';
import 'package:trivia/providers/profile.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  late bool isLoggedIn;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
        child: Column(
          children: [
            Center(
              child: Text(
                "Leaderboard",
                style: TextStyle(
                  color: AppColor.yellow,
                  fontSize: 50.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Provider.of<ProfileProvider>(context).hasProfile
                  ? Column(
                      children: [],
                    )
                  : Column(
                      children: [
                        const Spacer(flex: 5),
                        Text(
                          "You don't have a profile",
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 25.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "Would you like to create one now to see the leaderboard?",
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 25.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Spacer(flex: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ZoomTapAnimation(
                              onTap: () {
                                playTap(context);
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 15.sp,
                                  horizontal: 25.sp,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                                child: Text(
                                  "Maybe later",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                  ),
                                ),
                              ),
                            ),
                            ZoomTapAnimation(
                              onTap: () {
                                playTap(context);
                                showCreateProfileDialog(context);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 15.sp,
                                  horizontal: 25.sp,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                                child: Text(
                                  "Continue",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
