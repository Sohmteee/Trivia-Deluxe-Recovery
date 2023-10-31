import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:trivia/ad_helper.dart';
import 'package:trivia/main.dart';
import 'package:trivia/providers/money.dart';
import 'package:trivia/providers/stage.dart';
import 'package:trivia/screens/ad.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'game.dart';

RewardedAd? _rewardedAd;

void _loadRewardedAd() {
  RewardedAd.load(
    adUnitId: AdHelper.rewardedAdUnitId,
    request: const AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
      onAdLoaded: (ad) {
        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
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

showLowCashDialog(BuildContext context) {
  _loadRewardedAd();

  showGameDialog(
    context,
    child: Builder(builder: (dialogContext) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Lottie.asset(
              "assets/lottie/broke.json",
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            "Insufficient Coins!",
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
              "Would you like to continue by watching an ad?",
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
              _rewardedAd?.show(
                onUserEarnedReward: (_, reward) {
                  Navigator.pop(context);
                  Provider.of<MoneyProvider>(context, listen: false)
                      .increaseCoins(5);
                },
              );
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
                    "Okay, I'll watch an ad",
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
          Consumer<StageProvider>(builder: (context, stageProvider, _) {
            return ZoomTapAnimation(
              onTap: () {
                playTap(context);
                Navigator.of(dialogContext).pop();
                stageProvider.resetCompletedStage();
                Navigator.popAndPushNamed(dialogContext, "/select");
              },
              child: Container(
                width: double.maxFinite,
                padding:
                    EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Nah, I'll pass",
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
            );
          }),
        ],
      );
    }),
  );
}
