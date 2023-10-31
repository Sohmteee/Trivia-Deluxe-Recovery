import 'dart:io';

import 'package:flutter/foundation.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      if(kDebugMode) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else {
        return 'ca-app-pub-4696224049420135/8371135025';
      }
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        return "ca-app-pub-3940256099942544/1033173712";
      } else {
        return "ca-app-pub-4696224049420135/2927236653";
      }
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      if(kDebugMode) {
        return 'ca-app-pub-3940256099942544/5224354917';
      } else {
        return 'ca-app-pub-4696224049420135/1450503454';
      }
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get appOpenUnitID {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        return "ca-app-pub-3940256099942544/3419835294";
      } else {
        return "ca-app-pub-4696224049420135/6814510778";
      }
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/5662855259";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
