import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:trivia/colors/app_color.dart';
import 'package:trivia/main.dart';
import 'package:trivia/models/dialogs/exhausted_questions.dart';
import 'package:trivia/models/game_background.dart';
import 'package:trivia/models/level_tile.dart';
import 'package:trivia/models/stat_bar.dart';
import 'package:trivia/providers/question.dart';
import 'package:trivia/providers/stage.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class StageScreen extends StatefulWidget {
  const StageScreen({super.key});

  @override
  State<StageScreen> createState() => _StageScreenState();
}

class _StageScreenState extends State<StageScreen> {
  @override
  void initState() {
    playLevel(context);
    // loadBannerAd();
    Future.microtask(() {
      checkExhausted();
    });
    super.initState();
  }

  void checkExhausted() {
    final questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);
    questionProvider.initQuestionProvider(context);

    if (questionProvider.questionIndex ==
        questionProvider.questions.length - 1) {
      showExhaustedQuestionsDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "/select");
        return true;
      },
      child: GameBackground(
        body: Padding(
          padding: EdgeInsets.fromLTRB(30.w, 40.h, 30.w, 0),
          child: Column(
            children: [
              const GameStats(),
              const Spacer(),
              levelTitle(),
              const Spacer(),
              buildLevel(),
              const Spacer(flex: 3),
              playButton(),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Consumer<StageProvider> playButton() {
    return Consumer<StageProvider>(builder: (context, stageProvider, _) {
      return (stageProvider.completedStage != 3)
          ? SizedBox(
              height: 60.h,
              child: ZoomTapAnimation(
                onTap: () {
                  playTap(context);
                  Navigator.pushReplacementNamed(context, "/game");
                },
                child: Image.asset("assets/images/play.png"),
              ),
            )
          : const SizedBox();
    });
  }

  Consumer<QuestionProvider> levelTitle() {
    return Consumer<QuestionProvider>(builder: (context, questionProvider, _) {
      final stageProvider = Provider.of<StageProvider>(context);

      return stageProvider.completedStage != 0
          ? Text(
              "Level ${questionProvider.currentLevel + 1}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 50.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )
          : Text(
              "Level ${questionProvider.currentLevel + 1}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 50.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ).animate().slideX(
                duration: 1.seconds,
                begin: 10.h,
              );
    });
  }

  Stack buildLevel() {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(20.sp),
          width: double.maxFinite,
          height: 350.h,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2.sp,
              color: AppColor.lightRed,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(150.r),
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            width: double.maxFinite,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.sp,
                color: AppColor.lightRed,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(150.r),
              ),
            ),
            child: ListView.builder(
              itemCount: 3,
              padding: EdgeInsets.only(top: 20.h),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return LevelTile(
                  level: index + 1,
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: -40.h,
          right: 70.w,
          child: SizedBox(
            height: 150.h,
            child: Lottie.asset(
              "assets/lottie/chest.json",
              animate: false,
            ),
          ),
        ),
      ],
    );
  }
}
