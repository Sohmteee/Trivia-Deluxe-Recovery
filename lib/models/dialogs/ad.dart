import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:trivia/ad_helper.dart';
import 'package:trivia/main.dart';
import 'package:trivia/models/dialogs/low_cash.dart';
import 'package:trivia/providers/money.dart';
import 'package:trivia/screens/menu.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'game.dart';

showAdDialog(BuildContext context) {
  RewardedAd? _rewardedAd;

  void _loadRewardedAd() {
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
              _rewardedAd = null;
              _loadRewardedAd();
            },
          );

          _rewardedAd = ad;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  _loadRewardedAd();

  showGameDialog(
    context,
    isExitable: true,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Watch an ad to top up?",
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
            "This would give you 25 coins",
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 20.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 20.h),
        ZoomTapAnimation(
          onTap: () {
            playTap(context);
            if (rewardedAd != null) {
              pauseBGAudio();
              rewardedAd?.show(
                onUserEarnedReward: (_, reward) {
                  Provider.of<MoneyProvider>(context, listen: false)
                      .increaseCoins(5);
                  Navigator.pushReplacementNamed(context, "/stage");
                  playBGAudio(context);
                },
              );
            } else {
              ToastContext().init(context);
              Toast.show("Ad is not ready yet!",
                  duration: Toast.lengthLong, gravity: Toast.bottom);
            }
          },
          child: Container(
            width: double.maxFinite,
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
                    fontSize: 15.sp,
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
        SizedBox(height: 10.h),
        ZoomTapAnimation(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: double.maxFinite,
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
                  "Omo I dey manage my data",
                  style: TextStyle(
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                SizedBox(
                  height: 20.h,
                  child: Image.asset("assets/images/laugh.png"),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
