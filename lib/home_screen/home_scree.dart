import 'dart:async';

import 'package:app_demo_with_apsl_ads_kids/bindings/routes.dart';
import 'package:apsl_ads_flutter/apsl_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Using it to cancel the subscribed callbacks
  StreamSubscription? _streamSubscription;

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("APSL Ads"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(child: ApslNativeAd()),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: _showAdOnNavigation,
            child: const Text("Next Screen"),
          ),
        ],
      ),
    );
  }

  void _showAdOnNavigation() {
    if (ApslAds.instance.showAdOnNavigation()) {
      _streamSubscription?.cancel();
      _streamSubscription = ApslAds.instance.onEvent.listen((event) {
        if (event.adUnitType == AdUnitType.interstitial) {
          if (event.type == AdEventType.adFailedToLoad ||
              event.type == AdEventType.adDismissed) {
            _streamSubscription?.cancel();
            Get.toNamed(AppRoutes.nextScreen);
          }
        }
      });
    } else {
      Get.toNamed(AppRoutes.nextScreen);
    }
  }
}
