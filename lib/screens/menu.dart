import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:trivia/ad_helper.dart';
import 'package:trivia/colors/app_color.dart';
import 'package:trivia/colors/hex_color.dart';
import 'package:trivia/data/controllers.dart';
import 'package:trivia/main.dart';
import 'package:trivia/models/circle_border.dart';
import 'package:trivia/models/dialogs/exit.dart';
import 'package:trivia/models/dialogs/low_cash.dart';
import 'package:trivia/models/dialogs/settings.dart';
import 'package:trivia/providers/audio.dart';
import 'package:trivia/screens/reward.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late Animation<double> rotationAnimation;
  late Animation<double> reverseRotationAnimation;
  late AnimationController rotationController;

  BannerAd? _bannerAd;
  // AppOpenAd? _appOpenAd;
  // bool _appOpenIsLoaded = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    ToastContext().init(context);

    playBGAudio(context);
    // _loadAppOpenAd();
    _loadBannerAd();
    Future.microtask(() => initializeEffectsVolume());

    rotationController = AnimationController(duration: 100.seconds, vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          rotationController.repeat();
        }
      });

    rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(rotationController);

    reverseRotationAnimation = Tween<double>(
      begin: 2 * pi,
      end: 0,
    ).animate(rotationController);

    // Start the animation
    rotationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    rotationController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (rewardedAd == null || interstitialAd == null) {
          playBGAudio(context);
        }
        break;
      case AppLifecycleState.inactive:
        /* if (_appOpenIsLoaded) {
          _appOpenAd!.show();
        } */
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
        return showExitDialog(context);
      },
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/house.jpg"),
                fit: BoxFit.fill,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.black.withOpacity(.3),
              ),
              child: Center(
                child: Column(
                  children: [
                    topButtons(context),
                    const Spacer(flex: 4),
                    gameTitle()
                        .animate(
                          onPlay: (controller) => controller.repeat(),
                        )
                        .shimmer(
                          delay: 2.seconds,
                          duration: 1.seconds,
                        ),
                    const Spacer(flex: 3),
                    bottomButtons(context),
                    const Spacer(),
                    SizedBox(
                      width: _bannerAd!.size.width.toDouble(),
                      height: _bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row bottomButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          height: 60.h,
          child: ZoomTapAnimation(
            onTap: () {
              playTap(context);
              Navigator.pushNamed(context, "/leaderboard");
            },
            child: Lottie.asset(
              "assets/lottie/red_award.json",
              repeat: false,
              animate: true,
            ),
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            RotationTransition(
              turns: rotationAnimation,
              child: CustomPaint(
                painter: CircleBorderPainter(
                  color: HexColor("#FF8BA2").withOpacity(1), //#FF9FB9
                  radius: 46.sp,
                  angle: 1.8 * pi,
                  strokeWidth: 2.sp,
                ),
              ),
            ),
            RotationTransition(
              turns: reverseRotationAnimation,
              child: CustomPaint(
                painter: CircleBorderPainter(
                  color: const Color.fromARGB(255, 255, 153, 0).withOpacity(.9),
                  radius: 51.sp,
                  angle: -1.5 * pi,
                  strokeWidth: 6.sp,
                ),
              ),
            ),
            SizedBox(
              height: 70.w,
              child: ZoomTapAnimation(
                onTap: () {
                  playTap(context);
                  Navigator.pushNamed(context, "/select");
                },
                child: Image.asset("assets/images/play.png"),
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .then()
                .scaleXY(
                  curve: Curves.easeOutSine,
                  delay: 2.seconds,
                  duration: .2.seconds,
                  begin: 1,
                  end: .8,
                )
                .then()
                .scaleXY(
                  curve: Curves.easeOutSine,
                  duration: .4.seconds,
                  begin: .8,
                  end: 1.2,
                )
                .then()
                .scaleXY(
                  curve: Curves.bounceOut,
                  duration: .4.seconds,
                  begin: 1.2,
                  end: 1,
                ),
          ],
        ),
        Container(
          height: 50.h,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColor.yellow.withOpacity(.5),
                blurRadius: 20.sp,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ZoomTapAnimation(
            onTap: () {
              playTap(context);
              Navigator.pushNamed(context, "/streaks");
            },
            // child: Image.asset("assets/images/streak.png"),
            child: Lottie.asset(
              "assets/lottie/fire.json",
            ),
          ),
        ),
      ],
    );
  }

  Stack gameTitle() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          "TRIVIA\nDELUXE",
          style: TextStyle(
            color: HexColor("#A30F35"),
            fontSize: 90.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          "TRIVIA\nDELUXE",
          style: TextStyle(
            color: AppColor.white,
            fontSize: 80.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Row topButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.all(20.sp),
          child: ZoomTapAnimation(
            onTap: () {
              playTap(context);
              showExitDialog(context);
            },
            child: Container(
              padding: EdgeInsets.all(5.sp),
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
                Icons.close_rounded,
                size: 25.sp,
                color: AppColor.orange,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.sp),
          child: ZoomTapAnimation(
            onTap: () {
              playTap(context);
              showSettingsDialog(context);
            },
            child: Container(
              padding: EdgeInsets.all(5.sp),
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
                size: 25.sp,
                color: AppColor.orange,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void initializeEffectsVolume() {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);

    if (audioProvider.soundEffects) {
      audioProvider.setEffectsVolume(audioProvider.effectsVolume);
    }
  }

  /* void _loadAppOpenAd() {
    MobileAds.instance.initialize().then((InitializationStatus status) {
      AppOpenAd.load(
        adUnitId: AdHelper.appOpenUnitID,
        request: const AdRequest(),
        orientation: AppOpenAd.orientationPortrait,
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                Navigator.pushReplacementNamed(context, "/menu");
              },
            );

            setState(() {
              _appOpenAd = ad;
            });
          },
          onAdFailedToLoad: (err) {
            print('Failed to load an app open ad: ${err.message}');
          },
        ),
      );
    });
  } */

  _loadBannerAd() {
    _bannerAd = BannerAdd.
  }
}

Future<void> playBGAudio(context) async {
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
