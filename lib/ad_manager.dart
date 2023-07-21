import 'dart:async';
import 'dart:io';

import 'package:apsl_ads_flutter/apsl_ads_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class AdManager extends AdsIdManager {
  static final AdManager _instance = AdManager._internal();

  factory AdManager() {
    return _instance;
  }
  AdManager._internal();

  List<AppAdIds> appAdIdsList = [];
  int navigationAdCount = 0;

  StreamSubscription? _streamSubscription;

  // Load from Firebase
  Future<void> loadFromFirebase() async {
    final database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: "https://up-social-new-default-rtdb.firebaseio.com/",
    );

    final ref = database.ref();
    final snap = await ref.get();
    if (snap.exists) {
      updateAdInfo(snap);
    }

    ref.onValue.listen((event) {
      if (event.snapshot.exists) {
        updateAdInfo(event.snapshot);
      }
    });
  }

  // Update Ad Info
  // Update Ad Info on every change in Firebase
  void updateAdInfo(DataSnapshot snap) {
    final adInfo = AdInfo.fromJson(snap.value as Map<dynamic, dynamic>);
    navigationAdCount = adInfo.navigationAdCount;
    appAdIdsList = Platform.isAndroid ? adInfo.android : adInfo.ios;
  }

  // Get Ad Ids
  @override
  List<AppAdIds> get appAdIds => appAdIdsList;

  // Show Ad On Navigation
  void showAdOnNavigation(String routeName) {
    if (ApslAds.instance.showAdOnNavigation()) {
      _streamSubscription?.cancel();
      _streamSubscription = ApslAds.instance.onEvent.listen((event) {
        if (event.adUnitType == AdUnitType.interstitial) {
          if (event.type == AdEventType.adFailedToLoad ||
              event.type == AdEventType.adDismissed ||
              event.type == AdEventType.adShowed ||
              event.type == AdEventType.adFailedToShow) {
            _streamSubscription?.cancel();
            Get.toNamed(routeName);
          }
        }
      });
    } else {
      Get.toNamed(routeName);
    }
  }

  // Show rewarded or interstitial
  void showAd(
    AdUnitType adType, {
    Function? adFailed,
    Function? adDismissed,
    Function? earnedReward,
  }) {
    if (ApslAds.instance.showAd(adType)) {
      _streamSubscription?.cancel();
      _streamSubscription = ApslAds.instance.onEvent.listen((event) {
        if (event.adUnitType == adType) {
          if (event.type == AdEventType.adFailedToShow ||
              event.type == AdEventType.adFailedToLoad) {
            adFailed?.call();
          } else if (event.type == AdEventType.adDismissed) {
            adDismissed?.call();
          } else if (event.type == AdEventType.earnedReward) {
            earnedReward?.call();
          }
        }
      });
    }
  }
}

class AdInfo {
  final int navigationAdCount;
  final List<AppAdIds> android;
  final List<AppAdIds> ios;

  AdInfo({
    required this.navigationAdCount,
    required this.android,
    required this.ios,
  });

  factory AdInfo.fromJson(Map<dynamic, dynamic> json) {
    List<AppAdIds> androidList = List<AppAdIds>.from(json['android']
        .map((adNetworkJson) => AppAdIds.fromJson(adNetworkJson)));

    List<AppAdIds> iosList = List<AppAdIds>.from(
        json['ios'].map((adNetworkJson) => AppAdIds.fromJson(adNetworkJson)));

    return AdInfo(
      navigationAdCount: json['navigationAdCount'],
      android: androidList,
      ios: iosList,
    );
  }
}
