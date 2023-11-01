import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:trivia/ad_helper.dart';
import 'package:trivia/colors/app_color.dart';
import 'package:trivia/data/box.dart';
import 'package:trivia/main.dart';
import 'package:trivia/models/circle_tab_indicator.dart';
import 'package:trivia/models/dialogs/create_profile.dart';
import 'package:trivia/models/dialogs/leaderboard_scoring.dart';
import 'package:trivia/models/game_background.dart';
import 'package:trivia/providers/profile.dart';
import 'package:trivia/providers/question.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  var storage = FirebaseStorage.instance;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    _loadBannerAd();

    Future.microtask(() {
      final questionProvider =
          Provider.of<QuestionProvider>(context, listen: false);
      questionProvider.updateLeaderBoardScore(context);

      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      if (profileProvider.hasProfile) {
        profileProvider.updatePlayer(context);
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
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
    return GameBackground(
      body: Padding(
        padding: EdgeInsets.only(top: 20.h),
        child: Column(
          children: [
            Row(
              children: [
                BackButton(
                  color: AppColor.yellow,
                ),
                const Spacer(),
                Text(
                  "Leaderboard",
                  style: TextStyle(
                    color: AppColor.yellow,
                    fontSize: 50.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 3),
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Provider.of<ProfileProvider>(context).hasProfile
                  ? Provider.of<QuestionProvider>(context)
                              .totalQuestionsAnswered !=
                          0
                      ? Column(
                          children: [
                            leaderboardTab(),
                            SizedBox(height: 20.h),
                            leaderBoardTabBarView(),
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Please play at least one game to see leaderboard.",
                                style: TextStyle(
                                  color: AppColor.yellow,
                                  fontSize: 25.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                  : createProfilePrompt(context),
            ),
            SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          ],
        ),
      ),
    );
  }

  _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          _loadBannerAd();
        },
      ),
    )..load();
  }

  Padding createProfilePrompt(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        children: [
          const Spacer(flex: 5),
          Text(
            "You don't have a profile",
            style: TextStyle(
              color: AppColor.yellow,
              fontSize: 25.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          Text(
            "Would you like to create one now to see the leaderboard?",
            style: TextStyle(
              color: AppColor.yellow,
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
                    vertical: 10.sp,
                    horizontal: 15.sp,
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
                    vertical: 10.sp,
                    horizontal: 20.sp,
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
    );
  }

  Expanded leaderBoardTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: tabController,
        physics: const BouncingScrollPhysics(),
        children: List.generate(
          3,
          (index) {
            return FutureBuilder(
              future: getLeaderBoardData(index),
              initialData: null,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColor.yellow,
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "An error occured while fetching leaderboard data.",
                      style: TextStyle(
                        color: AppColor.yellow,
                        fontSize: 25.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                if (snapshot.data.length == 0) {
                  return Center(
                    child: Text(
                      switch (index) {
                        0 => "No data available for today.",
                        1 => "No data available for this week.",
                        2 => "No data available for this month.",
                        _ => "No data available.",
                      },
                      style: TextStyle(
                        color: AppColor.yellow,
                        fontSize: 25.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return popsicleLeaderBoard(snapshot, index);
              },
            );
          },
        ),
      ),
    );
  }

  Padding leaderboardTab() {
    return Padding(
      padding: EdgeInsets.only(left: 25.w),
      child: Align(
        alignment: Alignment.center,
        child: TabBar(
          controller: tabController,
          isScrollable: true,
          labelColor: AppColor.slightlyLighterYellow,
          unselectedLabelColor: Colors.grey[400],
          indicator: CircleTabIndicator(
            color: AppColor.slightlyLighterYellow,
          ),
          splashFactory: NoSplash.splashFactory,
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              return states.contains(MaterialState.focused)
                  ? null
                  : Colors.transparent;
            },
          ),
          tabs: [
            Column(
              children: [
                ZoomTapAnimation(
                  child: Text(
                    "Daily",
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
            Column(
              children: [
                ZoomTapAnimation(
                  child: Text(
                    "Weekly",
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
            Column(
              children: [
                ZoomTapAnimation(
                  child: Text(
                    "Monthly",
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column popsicleLeaderBoard(AsyncSnapshot<dynamic> snapshot, int index) {
    Container leaderboardHeads() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        height: 150.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            (snapshot.data.length >= 2)
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 65.h,
                            padding: EdgeInsets.all(2.sp),
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              // "assets/images/avatars/avatar_${snapshot.data[0]['avatar']}.png",
                              "assets/images/avatars/avatar_${snapshot.data[1]["avatar"]}.png",
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 50.w,
                            child: Column(
                              children: [
                                Text(
                                  "${snapshot.data[1]["username"]}",
                                  style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 18.sp,
                                      shadows: const [
                                        Shadow(
                                          color: Colors.black,
                                          offset: Offset(-2, 2),
                                          blurRadius: 5,
                                        ),
                                        Shadow(
                                          color: Colors.black,
                                          offset: Offset(-2, -2),
                                          blurRadius: 5,
                                        ),
                                      ]),
                                ),
                                Text(
                                  "${snapshot.data[1]["score"]}",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18.sp,
                                    shadows: const [
                                      Shadow(
                                        color: Colors.black,
                                        offset: Offset(-2, 2),
                                        blurRadius: 5,
                                      ),
                                      Shadow(
                                        color: Colors.black,
                                        offset: Offset(-2, -2),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0.w,
                            child: Image.asset(
                              "assets/images/medals/silver.png",
                              width: 30.w,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 43.h,
                        width: 3.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey,
                              AppColor.yellow,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ).animate().moveY(
                      duration: 1.seconds,
                      curve: Curves.easeInOut,
                      begin: 43.h,
                      end: 0,
                    )
                : SizedBox(width: 65.h),
            (snapshot.data.length >= 1)
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 70.h,
                            padding: EdgeInsets.all(2.sp),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 243, 165, 47),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              "assets/images/avatars/avatar_${snapshot.data[0]['avatar']}.png",
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0.w,
                            child: Image.asset(
                              "assets/images/medals/gold.png",
                              width: 30.w,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 50.w,
                            child: Column(
                              children: [
                                Text(
                                  "${snapshot.data[0]["username"]}",
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 247, 180, 81),
                                      fontSize: 18.sp,
                                      shadows: const [
                                        Shadow(
                                          color: Colors.black,
                                          offset: Offset(-2, 2),
                                          blurRadius: 5,
                                        ),
                                        Shadow(
                                          color: Colors.black,
                                          offset: Offset(-2, -2),
                                          blurRadius: 5,
                                        ),
                                      ]),
                                ),
                                Text(
                                  "${snapshot.data[0]["score"]}",
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 243, 165, 47),
                                    fontSize: 18.sp,
                                    shadows: const [
                                      Shadow(
                                        color: Colors.black,
                                        offset: Offset(-2, 2),
                                        blurRadius: 5,
                                      ),
                                      Shadow(
                                        color: Colors.black,
                                        offset: Offset(-2, -2),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 78.h,
                        width: 3.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromARGB(255, 243, 165, 47),
                              AppColor.yellow,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ).animate().moveY(
                      duration: 1.seconds,
                      curve: Curves.easeInOut,
                      begin: 78.h,
                      end: 0,
                    )
                : SizedBox(width: 70.h),
            (snapshot.data.length >= 3)
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 60.h,
                            padding: EdgeInsets.all(2.sp),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 177, 117, 95),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              "assets/images/avatars/avatar_${snapshot.data[2]['avatar']}.png",
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0.w,
                            child: Image.asset(
                              "assets/images/medals/bronze.png",
                              width: 30.w,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 50.w,
                            child: Column(
                              children: [
                                Text(
                                  "${snapshot.data[2]["username"]}",
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 226, 157, 132),
                                    fontSize: 18.sp,
                                    shadows: const [
                                      Shadow(
                                        color: Colors.black,
                                        offset: Offset(2, 2),
                                        blurRadius: 5,
                                      ),
                                      Shadow(
                                        color: Colors.black,
                                        offset: Offset(2, -2),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "${snapshot.data[2]["score"]}",
                                  style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 177, 117, 95),
                                    fontSize: 18.sp,
                                    shadows: const [
                                      Shadow(
                                        color: Colors.black,
                                        offset: Offset(2, 2),
                                        blurRadius: 5,
                                      ),
                                      Shadow(
                                        color: Colors.black,
                                        offset: Offset(2, -2),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 25.h,
                        width: 3.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromARGB(255, 177, 117, 95),
                              AppColor.yellow,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ).animate().moveY(
                      duration: 1.seconds,
                      curve: Curves.easeInOut,
                      begin: 25.h,
                      end: 0,
                    )
                : SizedBox(width: 60.h),
          ],
        ),
      );
    }

    Expanded leaderboardBody(int index) {
      return Expanded(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(top: 10.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30.r),
            ),
            gradient: LinearGradient(
              colors: [
                AppColor.yellow,
                AppColor.darkRed,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(flex: 3),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 6.h, horizontal: 15.w),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Current Position",
                          style: TextStyle(
                            color: AppColor.white,
                            fontSize: 20.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        FutureBuilder(
                          future: getLeaderBoardData(index),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            Map<String, dynamic> getPosition() {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // Data is still loading, return a default value or loading indicator.
                                return {
                                  "position": "---",
                                  "color": AppColor.white,
                                };
                              }

                              if (snapshot.hasError ||
                                  snapshot.data == null ||
                                  snapshot.data.isEmpty) {
                                // Handle the error state.
                                return {
                                  "position": "---",
                                  "color": AppColor.white,
                                };
                              }

                              // Find the index of the player with the specified device_id, if it exists.
                              int index = snapshot.data.indexWhere((profile) =>
                                  profile["device_id"] == deviceID);

                              if (index != -1) {
                                // Player with device_id found, adjust the index as needed.
                                index += 1;

                                Color color = index == 1
                                    ? const Color.fromARGB(255, 243, 165, 47)
                                    : index == 2
                                        ? Colors.grey
                                        : index == 3
                                            ? const Color.fromARGB(
                                                255, 211, 144, 120)
                                            : AppColor.white;

                                String suffix = (index >= 11 && index <= 13)
                                    ? "th"
                                    : {
                                          1: "st",
                                          2: "nd",
                                          3: "rd",
                                        }[index % 10] ??
                                        "th";

                                return {
                                  "position": "$index$suffix",
                                  "color": color,
                                };
                              }

                              // If the player with device_id is not found, you can return a default value.
                              return {
                                "position": "---",
                                "color": AppColor.white,
                              };
                            }

                            return Text(
                              getPosition()["position"],
                              style: TextStyle(
                                color: getPosition()["color"],
                                fontSize: 30.sp,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ZoomTapAnimation(
                    onTap: () {
                      playTap(context);
                      showLeaderBoardScoringDialog(context);
                    },
                    child: Icon(
                      Icons.help_outline,
                      color: Colors.grey[800],
                      size: 30.sp,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              if (snapshot.data.length >= 4)
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 0),
                    itemCount: snapshot.data.length - 3 >= 97
                        ? 97
                        : snapshot.data.length - 3,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 15.w),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${index + 3 + 1}",
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Image.asset(
                                  "assets/images/avatars/avatar_${snapshot.data[index + 3]["avatar"]}.png",
                                  height: 30.h,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  "${snapshot.data[index + 3]["username"]}",
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontSize: 20.sp,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(15.sp),
                              decoration: BoxDecoration(
                                  color: AppColor.slightlyLighterYellow
                                      .withOpacity(.8),
                                  shape: BoxShape.circle),
                              child: Text(
                                "${snapshot.data[index + 3]["score"]}",
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 10.h);
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        leaderboardHeads(),
        leaderboardBody(index),
      ],
    );
  }
}
