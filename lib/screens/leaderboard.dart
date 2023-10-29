import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trivia/colors/app_color.dart';
import 'package:trivia/data/box.dart';
import 'package:trivia/main.dart';
import 'package:trivia/models/circle_tab_indicator.dart';
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

class _LeaderBoardScreenState extends State<LeaderBoardScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  var storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);

    Future.microtask(() {
      final questionProvider =
          Provider.of<QuestionProvider>(context, listen: false);
      questionProvider.updateLeaderBoardScore(context);

      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      if (profileProvider.username != null) {
        profileProvider.updatePlayer(context);
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<List<QueryDocumentSnapshot>> getLeaderBoardData(int index) async {
    final fb = FirebaseFirestore.instance.collection("players");
    final querySnapshot = await fb.orderBy("score", descending: true).get();

    final leaderBoardData = querySnapshot.docs.map((doc) {
      return {
        "username": doc["username"],
        "score": doc["score"],
        "avatar": doc["avatar"],
      };
    }).toList();

    print(leaderBoardData);

    return querySnapshot.docs;
  }

  /* Future<List?> getLeaderBoardData(int index) async {
    String? getPeriod() {
      switch (index) {
        case 0:
          return "daily";
        case 1:
          return "week";
        case 2:
          return "month";
        default:
          return null;
      }
    }

    List<dynamic>? responseData;

    try {
      final response = await http.get(
        Uri.parse(
            "http://cbtportal.linkskool.com/api/get_leaderboard.php?game_type=triviaDTest&period=${getPeriod()}"),
        headers: {
          'Content-Type': 'application/json',
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
 */
  @override
  Widget build(BuildContext context) {
    return GameBackground(
      body: Padding(
        padding: EdgeInsets.only(top: 40.h),
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
                            Align(
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
                                overlayColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    return states
                                            .contains(MaterialState.focused)
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
                            SizedBox(height: 20.h),
                            Expanded(
                              child: TabBarView(
                                controller: tabController,
                                physics: const BouncingScrollPhysics(),
                                children: List.generate(
                                  3,
                                  (index) {
                                    return FutureBuilder(
                                      future: getLeaderBoardData(0),
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

                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 40.w),
                                              height: 150.h,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          Container(
                                                            height: 65.h,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2.sp),
                                                            decoration:
                                                                const BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              shape: BoxShape
                                                                  .circle,
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
                                                                      color: Colors
                                                                              .grey[
                                                                          400],
                                                                      fontSize:
                                                                          18.sp,
                                                                      shadows: const [
                                                                        Shadow(
                                                                          color:
                                                                              Colors.black,
                                                                          offset: Offset(
                                                                              -2,
                                                                              2),
                                                                          blurRadius:
                                                                              5,
                                                                        ),
                                                                        Shadow(
                                                                          color:
                                                                              Colors.black,
                                                                          offset: Offset(
                                                                              -2,
                                                                              -2),
                                                                          blurRadius:
                                                                              5,
                                                                        ),
                                                                      ]),
                                                                ),
                                                                Text(
                                                                  "${snapshot.data[1]["score"]}",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        18.sp,
                                                                    shadows: const [
                                                                      Shadow(
                                                                        color: Colors
                                                                            .black,
                                                                        offset: Offset(
                                                                            -2,
                                                                            2),
                                                                        blurRadius:
                                                                            5,
                                                                      ),
                                                                      Shadow(
                                                                        color: Colors
                                                                            .black,
                                                                        offset: Offset(
                                                                            -2,
                                                                            -2),
                                                                        blurRadius:
                                                                            5,
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
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Colors.grey,
                                                              AppColor.yellow,
                                                            ],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ).animate().moveY(
                                                        duration: 1.seconds,
                                                        curve: Curves.easeInOut,
                                                        begin: 43.h,
                                                        end: 0,
                                                      ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          Container(
                                                            height: 70.h,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2.sp),
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      243,
                                                                      165,
                                                                      47),
                                                              shape: BoxShape
                                                                  .circle,
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
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          247,
                                                                          180,
                                                                          81),
                                                                      fontSize:
                                                                          18.sp,
                                                                      shadows: const [
                                                                        Shadow(
                                                                          color:
                                                                              Colors.black,
                                                                          offset: Offset(
                                                                              -2,
                                                                              2),
                                                                          blurRadius:
                                                                              5,
                                                                        ),
                                                                        Shadow(
                                                                          color:
                                                                              Colors.black,
                                                                          offset: Offset(
                                                                              -2,
                                                                              -2),
                                                                          blurRadius:
                                                                              5,
                                                                        ),
                                                                      ]),
                                                                ),
                                                                Text(
                                                                  "${snapshot.data[0]["score"]}",
                                                                  style:
                                                                      TextStyle(
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        243,
                                                                        165,
                                                                        47),
                                                                    fontSize:
                                                                        18.sp,
                                                                    shadows: const [
                                                                      Shadow(
                                                                        color: Colors
                                                                            .black,
                                                                        offset: Offset(
                                                                            -2,
                                                                            2),
                                                                        blurRadius:
                                                                            5,
                                                                      ),
                                                                      Shadow(
                                                                        color: Colors
                                                                            .black,
                                                                        offset: Offset(
                                                                            -2,
                                                                            -2),
                                                                        blurRadius:
                                                                            5,
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
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              const Color
                                                                  .fromARGB(255,
                                                                  243, 165, 47),
                                                              AppColor.yellow,
                                                            ],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ).animate().moveY(
                                                        duration: 1.seconds,
                                                        curve: Curves.easeInOut,
                                                        begin: 78.h,
                                                        end: 0,
                                                      ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          Container(
                                                            height: 60.h,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2.sp),
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      243,
                                                                      165,
                                                                      47),
                                                              shape: BoxShape
                                                                  .circle,
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
                                                                  style:
                                                                      TextStyle(
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        226,
                                                                        157,
                                                                        132),
                                                                    fontSize:
                                                                        18.sp,
                                                                    shadows: const [
                                                                      Shadow(
                                                                        color: Colors
                                                                            .black,
                                                                        offset: Offset(
                                                                            2,
                                                                            2),
                                                                        blurRadius:
                                                                            5,
                                                                      ),
                                                                      Shadow(
                                                                        color: Colors
                                                                            .black,
                                                                        offset: Offset(
                                                                            2,
                                                                            -2),
                                                                        blurRadius:
                                                                            5,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "${snapshot.data[2]["score"]}",
                                                                  style:
                                                                      TextStyle(
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        177,
                                                                        117,
                                                                        95),
                                                                    fontSize:
                                                                        18.sp,
                                                                    shadows: const [
                                                                      Shadow(
                                                                        color: Colors
                                                                            .black,
                                                                        offset: Offset(
                                                                            2,
                                                                            2),
                                                                        blurRadius:
                                                                            5,
                                                                      ),
                                                                      Shadow(
                                                                        color: Colors
                                                                            .black,
                                                                        offset: Offset(
                                                                            2,
                                                                            -2),
                                                                        blurRadius:
                                                                            5,
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
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              const Color
                                                                  .fromARGB(255,
                                                                  177, 117, 95),
                                                              AppColor.yellow,
                                                            ],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ).animate().moveY(
                                                        duration: 1.seconds,
                                                        curve: Curves.easeInOut,
                                                        begin: 25.h,
                                                        end: 0,
                                                      ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(top: 5.h),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.vertical(
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
                                                child: (snapshot.data.length >=
                                                        4)
                                                    ? ListView.separated(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                20.w,
                                                                15.h,
                                                                20.w,
                                                                0),
                                                        itemCount: snapshot
                                                                .data.length -
                                                            3,
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        10.h,
                                                                    horizontal:
                                                                        15.w),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColor
                                                                  .white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.r),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      "${index + 3 + 1}",
                                                                      style:
                                                                          TextStyle(
                                                                        color: AppColor
                                                                            .black,
                                                                        fontSize:
                                                                            18.sp,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width: 10
                                                                            .w),
                                                                    Image.asset(
                                                                      "assets/images/avatars/avatar_${snapshot.data[index + 3]["avatar"]}.png",
                                                                      height:
                                                                          30.h,
                                                                    ),
                                                                    SizedBox(
                                                                        width: 10
                                                                            .w),
                                                                    Text(
                                                                      "${snapshot.data[index + 3]["username"]}",
                                                                      style:
                                                                          TextStyle(
                                                                        color: AppColor
                                                                            .black,
                                                                        fontSize:
                                                                            20.sp,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Container(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(15
                                                                              .sp),
                                                                  decoration: BoxDecoration(
                                                                      color: AppColor
                                                                          .slightlyLighterYellow
                                                                          .withOpacity(
                                                                              .8),
                                                                      shape: BoxShape
                                                                          .circle),
                                                                  child: Text(
                                                                    "${snapshot.data[index + 3]["score"]}",
                                                                    style:
                                                                        TextStyle(
                                                                      color: AppColor
                                                                          .white,
                                                                      fontSize:
                                                                          18.sp,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        separatorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return SizedBox(
                                                              height: 10.h);
                                                        },
                                                      )
                                                    : const Column(
                                                        children: [
                                                          Center(
                                                            child: Text(
                                                                "End of Leaderboard"),
                                                          ),
                                                        ],
                                                      ),
                                              ),
                                            ),
                                          ],
                                        );
                                        /* return ListView.separated(
                                      itemCount: snapshot.data.length,
                                      physics: const BouncingScrollPhysics(),
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
                                    ); */
                                      },
                                    );
                                  },
                                ),
                              ),
                            )

                            /* Expanded(
                              child: TabBarView(
                                controller: tabController,
                                physics: const BouncingScrollPhysics(),
                                children: List.generate(
                                  3,
                                  (index) {
                                    return FutureBuilder(
                                      future: getLeaderBoardData(index),
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

                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 40.w),
                                              height: 150.h,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          Container(
                                                            height: 65.h,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2.sp),
                                                            decoration:
                                                                const BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Image.asset(
                                                              // "assets/images/avatars/avatar_${snapshot.data[0]['avatar']}.png",
                                                              "assets/images/avatars/avatar_2.png",
                                                            ),
                                                          ),
                                                          Positioned(
                                                            bottom: 0,
                                                            left: 50.w,
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  "Alex Smith",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          400],
                                                                      fontSize:
                                                                          18.sp,
                                                                      shadows: const [
                                                                        Shadow(
                                                                          color:
                                                                              Colors.black,
                                                                          offset: Offset(
                                                                              -2,
                                                                              2),
                                                                          blurRadius:
                                                                              5,
                                                                        ),
                                                                        Shadow(
                                                                          color:
                                                                              Colors.black,
                                                                          offset: Offset(
                                                                              -2,
                                                                              -2),
                                                                          blurRadius:
                                                                              5,
                                                                        ),
                                                                      ]),
                                                                ),
                                                                Text(
                                                                  "35",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        18.sp,
                                                                    shadows: const [
                                                                      Shadow(
                                                                        color: Colors
                                                                            .black,
                                                                        offset: Offset(
                                                                            -2,
                                                                            2),
                                                                        blurRadius:
                                                                            5,
                                                                      ),
                                                                      Shadow(
                                                                        color: Colors
                                                                            .black,
                                                                        offset: Offset(
                                                                            -2,
                                                                            -2),
                                                                        blurRadius:
                                                                            5,
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
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Colors.grey,
                                                              AppColor.yellow,
                                                            ],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ).animate().moveY(
                                                        duration: 1.seconds,
                                                        curve: Curves.easeInOut,
                                                        begin: 43.h,
                                                        end: 0,
                                                      ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          Container(
                                                            height: 70.h,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2.sp),
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      243,
                                                                      165,
                                                                      47),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Image.asset(
                                                              // "assets/images/avatars/avatar_${snapshot.data[0]['avatar']}.png",
                                                              "assets/images/avatars/avatar_1.png",
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
                                                                  "John Doe",
                                                                  style: TextStyle(
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          247,
                                                                          180,
                                                                          81),
                                                                      fontSize:
                                                                          18.sp,
                                                                      shadows: const [
                                                                        Shadow(
                                                                          color:
                                                                              Colors.black,
                                                                          offset: Offset(
                                                                              -2,
                                                                              2),
                                                                          blurRadius:
                                                                              5,
                                                                        ),
                                                                        Shadow(
                                                                          color:
                                                                              Colors.black,
                                                                          offset: Offset(
                                                                              -2,
                                                                              -2),
                                                                          blurRadius:
                                                                              5,
                                                                        ),
                                                                      ]),
                                                                ),
                                                                Text(
                                                                  "36",
                                                                  style:
                                                                      TextStyle(
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        243,
                                                                        165,
                                                                        47),
                                                                    fontSize:
                                                                        18.sp,
                                                                    shadows: const [
                                                                      Shadow(
                                                                        color: Colors
                                                                            .black,
                                                                        offset: Offset(
                                                                            -2,
                                                                            2),
                                                                        blurRadius:
                                                                            5,
                                                                      ),
                                                                      Shadow(
                                                                        color: Colors
                                                                            .black,
                                                                        offset: Offset(
                                                                            -2,
                                                                            -2),
                                                                        blurRadius:
                                                                            5,
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
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              const Color
                                                                  .fromARGB(255,
                                                                  243, 165, 47),
                                                              AppColor.yellow,
                                                            ],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ).animate().moveY(
                                                        duration: 1.seconds,
                                                        curve: Curves.easeInOut,
                                                        begin: 78.h,
                                                        end: 0,
                                                      ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Stack(
                                                        clipBehavior: Clip.none,
                                                        children: [
                                                          Container(
                                                            height: 60.h,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2.sp),
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      177,
                                                                      117,
                                                                      95),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: Image.asset(
                                                              // "assets/images/avatars/avatar_${snapshot.data[0]['avatar']}.png",
                                                              "assets/images/avatars/avatar_3.png",
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
                                                                  "James Dude",
                                                                  style:
                                                                      TextStyle(
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        226,
                                                                        157,
                                                                        132),
                                                                    fontSize:
                                                                        18.sp,
                                                                    shadows: const [
                                                                      Shadow(
                                                                        color: Colors
                                                                            .black,
                                                                        offset: Offset(
                                                                            2,
                                                                            2),
                                                                        blurRadius:
                                                                            5,
                                                                      ),
                                                                      Shadow(
                                                                        color: Colors
                                                                            .black,
                                                                        offset: Offset(
                                                                            2,
                                                                            -2),
                                                                        blurRadius:
                                                                            5,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "34",
                                                                  style:
                                                                      TextStyle(
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        177,
                                                                        117,
                                                                        95),
                                                                    fontSize:
                                                                        18.sp,
                                                                    shadows: const [
                                                                      Shadow(
                                                                        color: Colors
                                                                            .black,
                                                                        offset: Offset(
                                                                            2,
                                                                            2),
                                                                        blurRadius:
                                                                            5,
                                                                      ),
                                                                      Shadow(
                                                                        color: Colors
                                                                            .black,
                                                                        offset: Offset(
                                                                            2,
                                                                            -2),
                                                                        blurRadius:
                                                                            5,
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
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              const Color
                                                                  .fromARGB(255,
                                                                  177, 117, 95),
                                                              AppColor.yellow,
                                                            ],
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ).animate().moveY(
                                                        duration: 1.seconds,
                                                        curve: Curves.easeInOut,
                                                        begin: 25.h,
                                                        end: 0,
                                                      ),
                                                ],
                                              ),
                                            ),
                                            // if (snapshot.data.length >= 4)
                                            Expanded(
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(top: 5.h),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.vertical(
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
                                                child: ListView.separated(
                                                  padding: EdgeInsets.fromLTRB(
                                                      20.w, 15.h, 20.w, 0),
                                                  itemCount: 20 - 3,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10.h,
                                                              horizontal: 15.w),
                                                      decoration: BoxDecoration(
                                                        color: AppColor.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50.r),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "${index + 3 + 1}",
                                                                style:
                                                                    TextStyle(
                                                                  color: AppColor
                                                                      .black,
                                                                  fontSize:
                                                                      18.sp,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 10.w),
                                                              Image.asset(
                                                                "assets/images/avatars/avatar_${index + 3 + 1}.png",
                                                                height: 30.h,
                                                              ),
                                                              SizedBox(
                                                                  width: 10.w),
                                                              Text(
                                                                "Username",
                                                                style:
                                                                    TextStyle(
                                                                  color: AppColor
                                                                      .black,
                                                                  fontSize:
                                                                      20.sp,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    15.sp),
                                                            decoration: BoxDecoration(
                                                                color: AppColor
                                                                    .slightlyLighterYellow
                                                                    .withOpacity(
                                                                        .8),
                                                                shape: BoxShape
                                                                    .circle),
                                                            child: Text(
                                                              "${30 - index + 3}",
                                                              style: TextStyle(
                                                                color: AppColor
                                                                    .white,
                                                                fontSize: 18.sp,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return SizedBox(
                                                        height: 10.h);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                        /* return ListView.separated(
                                      itemCount: snapshot.data.length,
                                      physics: const BouncingScrollPhysics(),
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
                                    ); */
                                      },
                                    );
                                  },
                                ),
                              ),
                            )
                           */
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
                                  color: AppColor.white,
                                  fontSize: 25.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Column(
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
            ),
          ],
        ),
      ),
    );
  }
}
