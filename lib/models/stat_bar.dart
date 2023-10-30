import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:trivia/colors/app_color.dart';
import 'package:trivia/data/box.dart';
import 'package:trivia/main.dart';
import 'package:trivia/models/dialogs/settings.dart';
import 'package:trivia/providers/money.dart';
import 'package:trivia/providers/question.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class GameStats extends StatefulWidget {
  const GameStats({
    super.key,
    this.showHome,
  });

  final bool? showHome;

  @override
  State<GameStats> createState() => _GameStatsState();
}

class _GameStatsState extends State<GameStats> {
  bool animateCoins = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final coins = Provider.of<MoneyProvider>(context, listen: false);
      coins.addListener(() {
        setState(() {
          animateCoins = true;
          debugPrint("Animate coins: $animateCoins");
        });
      });
    });
  }

  @override
  void dispose() {
  
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> getLeaderBoardData(int index) async {
    DateTime constraint = switch (index) {
      0 => DateTime.now().subtract(1.days),
      1 => DateTime.now().subtract(7.days),
      2 => DateTime.now().subtract(30.days),
      _ => DateTime.now().subtract(1.days),
    };
    final fb = FirebaseFirestore.instance.collection("players");
    final querySnapshot = await fb.orderBy("score", descending: true).get();

    final leaderBoardData = querySnapshot.docs.map((doc) {
      return {
        "username": doc["username"],
        "score": doc["score"],
        "avatar": doc["avatar"],
        "time": doc["time"],
        "device_id": doc["device_id"],
      };
    }).where((player) {
      Timestamp timestamp = player["time"];
      DateTime playerTime = timestamp.toDate();
      return playerTime.isAfter(constraint);
    }).toList();

    print(leaderBoardData);

    return leaderBoardData;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.showHome ?? true != false)
          ZoomTapAnimation(
            onTap: () {
              playTap(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, "/menu", (route) => false);
            },
            child: Container(
              padding: EdgeInsets.all(2.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.lightRed,
                  width: 2.sp,
                ),
                gradient: LinearGradient(
                  colors: [
                    AppColor.lightRed,
                    AppColor.darkRed,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Icons.home_rounded,
                size: 22.sp,
                color: AppColor.orange,
              ),
            ),
          ),
        if (widget.showHome ?? true != false) const Spacer(flex: 4),
        Lottie.asset(
          "assets/lottie/red_award.json",
          height: 20.h,
          repeat: false,
          animate: true,
        ),
        SizedBox(width: 5.w),
        ZoomTapAnimation(
          onTap: () {
            playTap(context);
          },
          child: Container(
            height: 20.h,
            width: 60.w,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: AppColor.lightRed,
                width: 2.sp,
              ),
              borderRadius: BorderRadius.circular(15.r),
              gradient: LinearGradient(
                colors: [
                  AppColor.lightRed,
                  AppColor.darkRed,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: FutureBuilder(
                future: getLeaderBoardData(0),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  String getPosition() {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Data is still loading, return a default value or loading indicator.
                      return "---";
                    }

                    if (snapshot.hasError ||
                        snapshot.data == null ||
                        snapshot.data.isEmpty) {
                      // Handle the error state.
                      return "---";
                    }

                    if (Provider.of<QuestionProvider>(context)
                            .totalQuestionsAnswered ==
                        0) {
                      return "---";
                    }

                    // Find the index of the player with the specified device_id, if it exists.
                    int index = snapshot.data.indexWhere(
                        (profile) => profile["device_id"] == deviceID);

                    // If the player with device_id is found, return the position.
                    if (index != -1) {
                      index += 1;

                      // Add the appropriate suffix to the index.
                      String suffix = switch (index % 10) {
                        1 => "st",
                        2 => "nd",
                        3 => "rd",
                        _ => "th",
                      };

                      return "$index$suffix";
                    }

                    // If the player with device_id is not found, you can return a default value.
                    return "---";
                  }

                  return Text(
                    getPosition(),
                    style: TextStyle(
                      color: AppColor.yellow,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const Spacer(flex: 4),
        Container(
          height: 20.h,
          padding: EdgeInsets.all(2.sp),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppColor.lightRed,
              width: 2.sp,
            ),
            borderRadius: BorderRadius.circular(8.r),
            gradient: LinearGradient(
              colors: [
                AppColor.lightRed,
                AppColor.darkRed,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Image.asset("assets/images/coin.png"),
        ),
        SizedBox(width: 5.w),
        Consumer<MoneyProvider>(
          builder: (context, moneyProvider, _) {
            return ZoomTapAnimation(
              onTap: () {
                playTap(context);
              },
              child: Container(
                height: 20.h,
                width: 60.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: AppColor.lightRed,
                    width: 2.sp,
                  ),
                  borderRadius: BorderRadius.circular(15.r),
                  gradient: LinearGradient(
                    colors: [
                      AppColor.lightRed,
                      AppColor.darkRed,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: animateCoins
                      ? Countup(
                          begin: moneyProvider.previousCoins.toDouble(),
                          end: moneyProvider.coins.toDouble(),
                          duration: 1.seconds,
                          style: const TextStyle(
                            color: Colors.yellow,
                          ),
                        )
                      : Text(
                          moneyProvider.coins.toString(),
                          style: const TextStyle(
                            color: Colors.yellow,
                          ),
                        ),
                ),
              ),
            );
          },
        ),
        if (widget.showHome ?? true != false) const Spacer(flex: 4),
        if (widget.showHome ?? true != false)
          ZoomTapAnimation(
            onTap: () {
              playTap(context);
              showSettingsDialog(context);
            },
            child: Container(
              padding: EdgeInsets.all(2.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.lightRed,
                  width: 2.sp,
                ),
                gradient: LinearGradient(
                  colors: [
                    AppColor.lightRed,
                    AppColor.darkRed,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Icons.settings_rounded,
                size: 22.sp,
                color: AppColor.orange,
              ),
            ),
          ),
      ],
    );
  }
}
