import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trivia/colors/app_color.dart';
import 'package:trivia/data/controllers.dart';
import 'package:trivia/main.dart';
import 'package:trivia/models/game_background.dart';
import 'package:trivia/models/stat_bar.dart';
import 'package:trivia/providers/question.dart';
import 'package:trivia/providers/streaks.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late ConfettiController confettiController;
  Color fillColor = Colors.green[300]!;
  int iterationCount = 30;
  late Timer timer;
  bool answered = false;

  @override
  void initState() {
    final questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);

    confettiController = ConfettiController(duration: 1.5.seconds);
    Future.microtask(() => questionProvider.initQuestionProvider(context));
    Future.delayed(
        3.5.seconds, () => (!answered) ? countDownController.start() : null);

    super.initState();
  }

  @override
  void dispose() {
    final questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);
    confettiController.dispose();
    countDownController.reset();
    questionProvider.resetOptions();
    super.dispose();
  }

  Color stringToColor(String color) {
    switch (color) {
      case "yellow":
        return AppColor.yellow;
      case "right":
        return AppColor.right;
      case "wrong":
        return AppColor.wrong;
      default:
        return AppColor.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, "/stage");
        return true;
      },
      child: GameBackground(
        body: Consumer<QuestionProvider>(
          builder: (context, questionProvider, _) {
            return Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.w,
                        vertical: 40.h,
                      ),
                      child: const GameStats(
                        showHome: false,
                      ),
                    ),
                    buildQuestion(),
                    buildOptions(questionProvider),
                  ],
                ),
                ConfettiWidget(
                  confettiController: confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  emissionFrequency: 0.6,
                  minimumSize: const Size(10, 10),
                  maximumSize: const Size(10, 10),
                  numberOfParticles: 5,
                  gravity: .7,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple,
                  ],
                  // createParticlePath: drawStar,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Expanded buildOptions(QuestionProvider questionProvider) {
    return Expanded(
      child: ListView.builder(
        itemCount: 4,
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return ZoomTapAnimation(
            onTap: () {
              final streaksProvider =
                  Provider.of<StreaksProvider>(context, listen: false);

              countDownController.pause();

              if (!answered) {
                streaksProvider.count++;

                if (questionProvider.options[index]["value"] == true) {
                  playCorrect(context);
                  confettiController.play();
                  streaksProvider.updateTriviaStreak(true);
                } else {
                  playWrong(context);
                  streaksProvider.updateTriviaStreak(false);
                }

                questionProvider.checkCorrectAnswer(
                  context,
                  index,
                  answered: answered,
                  timeElapsed: countDownController.getTime()!,
                );

                setState(() {
                  answered = true;
                });
              }
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 20.h),
              padding: EdgeInsets.all(15.sp),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: stringToColor(questionProvider.options[index]["color"]),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                "${optionLetter(index)}:  ${questionProvider.options[index]["text"]}",
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: 20.sp,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ).animate().slideY(
                delay: 2.5.seconds,
                duration: (300 + (index * 100)).milliseconds,
                begin: 10,
                end: 0,
              );
        },
      ),
    );
  }

  Padding buildQuestion() {
    final questionProvider = Provider.of<QuestionProvider>(context);

    Color getColor(int time) {
      if (time > 15) {
        return Colors.green[400]!;
      } else {
        if (time > 5) {
          return Colors.yellow[400]!;
        }
        return Colors.red[400]!;
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 250.h,
            padding: EdgeInsets.all(10.sp),
            width: double.maxFinite,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.sp,
                color: AppColor.lightRed,
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.sp,
                vertical: 30.sp,
              ),
              width: double.maxFinite,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2.sp,
                  color: AppColor.lightRed,
                ),
                gradient: LinearGradient(
                  colors: [
                    AppColor.darkRed,
                    AppColor.lightRed,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: AutoSizeText(
                  minFontSize: 20,
                  questionProvider.question,
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: 30.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ).animate().scaleXY(
                curve: Curves.easeInCubic,
                delay: .5.seconds,
                duration: .5.seconds,
                begin: 0,
                end: 1,
              ),
          Positioned(
            top: -20.h,
            child: CircularCountDownTimer(
              duration: 30,
              controller: countDownController,
              width: 70,
              height: 70,
              ringColor: Colors.transparent,
              ringGradient: null,
              fillColor: Colors.grey[300]!,
              fillGradient: null,
              backgroundColor: getColor(iterationCount - 1),
              backgroundGradient: null,
              strokeWidth: 3,
              strokeCap: StrokeCap.round,
              textStyle: TextStyle(
                fontSize: 33.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textFormat: CountdownTextFormat.S,
              isReverse: true,
              isReverseAnimation: true,
              isTimerTextShown: true,
              autoStart: false,
              onStart: () {
                debugPrint('Countdown Started');

                timer = Timer.periodic(1.seconds, (timer) {
                  if (iterationCount > 0) {
                    setState(() {
                      iterationCount--;
                    });
                  } else {
                    timer.cancel();
                  }
                });
              },
              onComplete: () {
                debugPrint('Countdown Ended');

                questionProvider.checkCorrectAnswer(context, -1);
              },
              timeFormatterFunction: (defaultFormatterFunction, duration) {
                return Function.apply(defaultFormatterFunction, [duration]);
              },
            ).animate().slideX(
                  curve: Curves.easeInSine,
                  delay: 2.5.seconds,
                  duration: 1.seconds,
                  begin: 20,
                  end: 0,
                ),
          ),
        ],
      ),
    );
  }

  String optionLetter(int index) {
    switch (index) {
      case 0:
        return "A";
      case 1:
        return "B";
      case 2:
        return "C";
      case 3:
        return "D";
      default:
        return "";
    }
  }
}
