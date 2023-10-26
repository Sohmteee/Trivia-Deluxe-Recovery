import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:trivia/colors/app_color.dart';
import 'package:trivia/main.dart';
import 'package:trivia/models/dialogs/create_profile.dart';
import 'package:trivia/models/game_background.dart';
import 'package:trivia/providers/profile.dart';
import 'package:trivia/providers/question.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  late bool isLoggedIn;
  List<dynamic> responseData = [];

  Future<void> getLeaderBoardData() async {
    try {
      final response = await http.get(
        Uri.parse(
            "http://cbtportal.linkskool.com/api/get_leaderboard.php?game_type=triviaDeluxe&period=daily"),
        headers: {
          'Content-Type': 'application/json',

          // 'Authorization': 'Token $apiKey',
        },
      );

      responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Request was successful
        print(responseData);
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      body: Padding(
        padding: EdgeInsets.fromLTRB(40.w, 40.h, 40.w, 0),
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
            SizedBox(height: 20.h),
            Expanded(
              child: Provider.of<ProfileProvider>(context).hasProfile
                  ? Provider.of<QuestionProvider>(context)
                              .totalQuestionsAnswered !=
                          0
                      ? Column(
                          children: [
                            Expanded(
                              child: FutureBuilder(
                                future: Future.delayed(.1.seconds,() {
                                 if (Provider.of<ProfileProvider>(context, listen: false).hasProfile) {
      getLeaderBoardData();
    }),
                                initialData: InitialData,
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  return ;
                                },
                              ),
                              
                              
                              ListView.separated(
                                itemCount: 20,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.white,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: ListTile(
                                      tileColor: AppColor.white,
                                      leading: Text(
                                        "${index + 1}",
                                        style: TextStyle(
                                          color: AppColor.black,
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                      title: Text(
                                        "Name",
                                        style: TextStyle(
                                          color: AppColor.black,
                                          fontSize: 30.sp,
                                        ),
                                      ),
                                      trailing: Text(
                                        "Score",
                                        style: TextStyle(
                                          color: AppColor.black,
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return SizedBox(height: 10.h);
                                },
                              ),
                            )
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Please play at least one game to see leaderboard.",
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: 25.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
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
