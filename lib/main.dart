import 'dart:io';

import 'package:apsl_ads_flutter/apsl_ads_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ad_manager.dart';
import '../bindings/bindings.dart';
import '../bindings/routes.dart';
import 'firebase_options.dart';

final AdManager adsIdManager = AdManager();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await adsIdManager.loadFromFirebase();

  await ApslAds.instance.initialize(
    isShowAppOpenOnAppStateChange: true,
    adsIdManager,
    unityTestMode: true,
    fbTestMode: true,
    fbTestingId: "DB4376A4F649F3EECA878BB77ED7BA08",
    adMobAdRequest: const AdRequest(),
    admobConfiguration: RequestConfiguration(testDeviceIds: []),
    showAdBadge: Platform.isIOS,
    fbiOSAdvertiserTrackingEnabled: true,
    showNavigationAdAfterCount: adsIdManager.navigationAdCount,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.homeScreen,
      initialBinding: HomeScreenBindings(),
      getPages: AppRoutes.routes,
    );
  }
}
