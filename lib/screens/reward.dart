import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:trivia/ad_helper.dart';
import 'package:trivia/colors/app_color.dart';
import 'package:trivia/data/controllers.dart';
import 'package:trivia/main.dart';
import 'package:trivia/models/game_background.dart';
import 'package:trivia/models/stat_bar.dart';
import 'package:trivia/providers/audio.dart';
import 'package:trivia/providers/money.dart';
import 'package:trivia/providers/profile.dart';
import 'package:trivia/providers/question.dart';
import 'package:trivia/providers/streaks.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  InterstitialAd? _interstitialAd;
  bool receivedReward = false;
  late int score;
  late int level;
  late ConfettiController vitoryConfettiController;
  final offset = const Offset(20, -350);
  late Path path;

  bool countUp = false,
      claimReward = false,
      playedCoinUp = false,
      levelAnimation = false;

  @override
  void initState() {
    playVictory(context);
    _loadInterstitialAd();
    Future.delayed(.5.seconds, () {
      bgPlayer.pause();
      Future.delayed(4.seconds, () => bgPlayer.resume());
    });
    final questionProvider =
        Provider.of<QuestionProvider>(context, listen: false);
    level = questionProvider.currentLevel;
    path = Path()
      ..arcToPoint(
        offset,
        radius: const Radius.circular(300),
        clockwise: true,
      );
    vitoryConfettiController = ConfettiController(duration: 1.5.seconds);
    final moneyProvider = Provider.of<MoneyProvider>(context, listen: false);
    score = moneyProvider.reward;
    moneyProvider.resetReward();

    final streaksProvider =
        Provider.of<StreaksProvider>(context, listen: false);

    if (streaksProvider.count == 3) {
      streaksProvider.updateLevelStreak(true);
    } else {
      streaksProvider.updateLevelStreak(false);
    }
    streaksProvider.count = 0;

    // score = 18;

    // final moneyProvider = Provider.of<MoneyProvider>(context, listen: false);
    // moneyProvider.resetCoins();

    questionProvider.incrementLevel();

    Future.delayed(5.5.seconds, () {
      setState(() {
        countUp = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    victoryPlayer.dispose();
    vitoryConfettiController.dispose();

    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    Future<void> playBGAudio() async {
      final audioProvider = Provider.of<AudioProvider>(context, listen: false);

      if (audioProvider.music) {
        await bgPlayer.setSource(AssetSource("audio/bg-music.mp3"));
        await bgPlayer.resume();
        debugPrint("music playing");
      }

      bgPlayer.onPlayerComplete.listen((_) async {
        await bgPlayer.setSource(AssetSource("audio/bg-music.mp3"));
        await bgPlayer.resume();
      });
    }

    Future<void> pauseBGAudio() async {
      await bgPlayer.pause();
      debugPrint("music paused");
    }

    Future<void> stopBGAudio() async {
      await bgPlayer.stop();
      debugPrint("music stopped");
    }

    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
        playBGAudio();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        pauseBGAudio();
        break;
      case AppLifecycleState.detached:
        stopBGAudio();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        playTap(context);
        Navigator.pushNamedAndRemoveUntil(context, "/menu", (route) => false);
        return true;
      },
      child: GameBackground(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
          child: Column(
            children: [
              const GameStats(),
              SizedBox(height: 20.h),
              rewardTitle(),
              const Spacer(flex: 2),
              chestBox(context).animate().slideX(
                    delay: 2.seconds,
                    duration: 2.seconds,
                    begin: 20.h,
                    end: 0,
                  ),
              const Spacer(flex: 3),
              if (receivedReward)
                rewardButton(context)
                    .animate()
                    .slideY(
                      delay: 1.5.seconds,
                      duration: 1.seconds,
                      curve: Curves.easeOut,
                      begin: -3.h,
                      end: 0,
                    )
                    .fadeIn(
                      delay: 1.9.seconds,
                      duration: 1.seconds,
                    ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  ZoomTapAnimation rewardButton(BuildContext context) {
    return ZoomTapAnimation(
      onTap: () {
        playTap(context);
        if (_interstitialAd != null) {
          pauseBGAudio();
          _interstitialAd?.show();
        } else {
          if (level <= 28) {
            Navigator.pushReplacementNamed(context, "/stage");
          } else {
            Navigator.pushReplacementNamed(context, "/select");
          }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 15.h,
          horizontal: 30.w,
        ),
        decoration: BoxDecoration(
          color: AppColor.right,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Text(
          level <= 28
              ? "Continue to Level ${level + 2}"
              : "Select Another Category",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  SizedBox chestBox(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          !claimReward
              ? Text(
                  "You earned",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeOut(
                    delay: 7.seconds,
                    duration: .5.seconds,
                    begin: 1,
                  )
              : const Spacer(),
          const SizedBox(width: 10),
          !claimReward
              ? SizedBox(
                  child: countUp
                      ? Countup(
                          begin: 0,
                          end: score.toDouble(),
                          duration: 1.seconds,
                          style: TextStyle(
                            color: AppColor.right,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Text(
                          "0",
                          style: TextStyle(
                            color: AppColor.right,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                )
                  .animate(
                    onComplete: (controller) {
                      Future.delayed(1.seconds, () {
                        setState(() {
                          claimReward = true;
                          final moneyProvider = Provider.of<MoneyProvider>(
                              context,
                              listen: false);
                          final streaksProvider = Provider.of<StreaksProvider>(
                              context,
                              listen: false);
                          final questionProvider =
                              Provider.of<QuestionProvider>(context,
                                  listen: false);

                          Future.delayed(2.seconds, () {
                            playCoinUp(context);
                            moneyProvider.increaseCoins(score);
                            streaksProvider
                                .updateCoinStreak(moneyProvider.coins);
                            questionProvider.updateLeaderBoardScore(context);

                            final profileProvider =
                                Provider.of<ProfileProvider>(context,
                                    listen: false);
                            if (profileProvider.username != null) {
                              profileProvider.updatePlayer(context);
                            }
                          });
                        });
                      });
                    },
                  )
                  .slideX(
                    duration: .5.seconds,
                    begin: -20.w,
                    end: 0,
                  )
                  .then()
                  .slideX(
                    delay: 6.5.seconds,
                    duration: .5.seconds,
                    begin: 0,
                    end: -1.w,
                  )
                  .slideY(
                    delay: 6.5.seconds,
                    duration: .5.seconds,
                    begin: 0,
                    end: 1.w,
                  )
              : Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Stack(
                      children: List.generate(
                        score,
                        (index) => SizedBox(
                          width: 30.w,
                          child: Image.asset("assets/images/coin.png"),
                        ),
                      )
                          .animate(
                              interval: 100.milliseconds,
                              onPlay: (controller) {},
                              onComplete: (controller) {
                                setState(() {
                                  receivedReward = true;
                                  if (!playedCoinUp) {
                                    setState(() {
                                      playedCoinUp = true;
                                    });
                                  }
                                });
                              })
                          .followPath(
                            path: path,
                            delay: 1.seconds,
                            duration: .6.seconds,
                          )
                          .fadeOut(
                            delay: 1.seconds,
                            duration: .7.seconds,
                          ),
                    ),
                    SizedBox(
                      height: 200.h,
                      width: 200.w,
                      child: Lottie.asset(
                        "assets/lottie/chest.json",
                        repeat: false,
                      ),
                    ),
                  ],
                ).animate().fadeIn(
                    duration: .5.seconds,
                    begin: 0,
                  ),
          const SizedBox(width: 10),
          !claimReward
              ? Text(
                  "coins",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeOut(
                    delay: 7.seconds,
                    duration: .5.seconds,
                    begin: 1,
                  )
              : const Spacer(),
        ],
      )
          .animate(
            onPlay: (controller) => controller.repeat(),
          )
          .shimmer(
            delay: 2.seconds,
            duration: 1.seconds,
          ),
    );
  }

  Row rewardTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConfettiWidget(
          confettiController: vitoryConfettiController,
          blastDirection: 0,
          emissionFrequency: 0.6,
          minimumSize: const Size(10, 10),
          maximumSize: const Size(10, 10),
          numberOfParticles: 5,
          gravity: .3,
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple,
          ],
        ),
        level <= 28
            ? SizedBox(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Lottie.asset(
                      "assets/lottie/celebration.json",
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                    Text(
                      "Level\nPassed!",
                      style: TextStyle(
                        color: AppColor.right,
                        fontSize: 55.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Level\nPassed!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(),
                    )
                    .shimmer(
                      delay: 2.seconds,
                      duration: 1.seconds,
                    ),
              )
                .animate(
                  onPlay: (controller) => Future.delayed(
                    1.seconds,
                    () => vitoryConfettiController.play(),
                  ),
                )
                .scaleXY(
                  delay: .3.seconds,
                  duration: 1.seconds,
                  curve: Curves.bounceOut,
                  begin: 0,
                  end: 1.4,
                )
                .then()
                .scaleXY(
                  delay: 2.seconds,
                  curve: Curves.bounceOut,
                  duration: .3.seconds,
                  begin: 1.4,
                  end: 1,
                )
            : SizedBox(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Lottie.asset(
                      "assets/lottie/celebration.json",
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                    Text(
                      "Category\nCompleted!",
                      style: TextStyle(
                        color: AppColor.right,
                        fontSize: 51.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Category\nCompleted!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
                    .animate(
                      onPlay: (controller) => controller.repeat(),
                    )
                    .shimmer(
                      delay: 2.seconds,
                      duration: 1.seconds,
                    ),
              )
                .animate(
                  onPlay: (controller) => Future.delayed(
                    1.seconds,
                    () => vitoryConfettiController.play(),
                  ),
                )
                .scaleXY(
                  delay: .3.seconds,
                  duration: 1.seconds,
                  curve: Curves.bounceOut,
                  begin: 0,
                  end: 1.4,
                )
                .then()
                .scaleXY(
                  delay: 2.seconds,
                  curve: Curves.bounceOut,
                  duration: .3.seconds,
                  begin: 1.4,
                  end: 1,
                ),
        ConfettiWidget(
          confettiController: vitoryConfettiController,
          blastDirection: pi,
          emissionFrequency: 0.6,
          minimumSize: const Size(10, 10),
          maximumSize: const Size(10, 10),
          numberOfParticles: 5,
          gravity: .3,
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple,
          ],
        ),
      ],
    );
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Navigator.pushReplacementNamed(context, "/stage");
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },

        on
      ),
    );
  }
}
