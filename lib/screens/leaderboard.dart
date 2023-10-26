import 'dart:convert';

import 'package:flutter/material.dart';
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
  Future<List?> getLeaderBoardData() async {
    List<dynamic>? responseData;

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

    return responseData;
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
                                future: getLeaderBoardData(),
                                initialData: null,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.data == null) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: AppColor.yellow,
                                      ),
                                    );
                                  }
                                  if (snapshot.hasError ||
                                      snapshot.data == []) {
                                    return Center(
                                      child: Text(
                                        "An error occured while fetching leaderboard data.",
                                        style: TextStyle(
                                          color: AppColor.white,
                                          fontSize: 25.sp,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }

                                  print(List.generate(
                                      snapshot.data.length,
                                      (index) =>
                                          snapshot.data[index]["username"]));
                                  print(snapshot.hasData);
                                  return ListView.separated(
                                    itemCount: snapshot.data.length,
                                    
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.white,
                                          borderRadius:
                                              BorderRadius.circular(20.r),
                                        ),
                                        child: ListTile(
                                          tileColor: AppColor.white,
                                          leading: Image.asset(
                                            "assets/images/avatars/avatar_${snapshot.data[index]['avatar']}.png",
                                            height: 30.h,
                                          ),
                                          title: Text(
                                            "${snapshot.data[index]['username']}",
                                            style: TextStyle(
                                              color: AppColor.black,
                                              fontSize: 20.sp,
                                            ),
                                          ),
                                          trailing: Text(
                                            "${snapshot.data[index]['score']}",
                                            style: TextStyle(
                                              color: AppColor.black,
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(height: 10.h);
                                    },
                                  );
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
