import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:trivia/colors/app_color.dart';
import 'package:trivia/main.dart';
import 'package:trivia/models/dialogs/low_cash.dart';
import 'package:trivia/providers/money.dart';
import 'package:trivia/providers/profile.dart';
import 'package:trivia/providers/question.dart';
import 'package:trivia/screens/menu.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'game.dart';

showAdDialog(BuildContext context) {
/*   RewardedAd? rewardedAd;

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              pauseBGAudio();
            },
            onAdDismissedFullScreenContent: (ad) {
              playBGAudio(context);
              ad.dispose();
              rewardedAd = null;
            },
          );

          rewardedAd = ad;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  } */

  loadRewardedAd(context, isStatBar: true);

  showGameDialog(
    context,
    isExitable: true,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Watch an AD to Top Up?",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Text(
            "This will give you 5 coins",
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 20.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 30.h),
        ZoomTapAnimation(
          onTap: () {
            if (rewardedAd != null) {
              Navigator.pop(context);
              pauseBGAudio();
              rewardedAd?.show(
                onUserEarnedReward: (_, reward) {
                  Provider.of<MoneyProvider>(context, listen: false)
                      .increaseCoins(5);
                  Provider.of<QuestionProvider>(context, listen: false)
                      .updateLeaderBoardScore(context);
                  Provider.of<ProfileProvider>(context, listen: false)
                      .updatePlayer(context);
                },
              );
            } else {
              playTap(context);
              ToastContext().init(context);
              Toast.show(
                "Ad is not ready yet, try again after some time.",
                duration: Toast.lengthLong,
                backgroundColor: AppColor.slightlyLighterYellow,
                gravity: Toast.bottom,
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
              );
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Okay I'll watch it",
                  style: TextStyle(
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                SizedBox(
                  height: 20.h,
                  child: Image.asset("assets/images/youtube.png"),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
