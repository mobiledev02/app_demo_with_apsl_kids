import 'package:apsl_ads_flutter/apsl_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home_screen/home_controller.dart';

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    homeController.incrementNavigationCount();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Next Screen"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Obx(
                () =>
                    Text("Next Screen ${homeController.navigationCountValue}"),
              ),
            ),
          ),
          const ApslSequenceBannerAd(),
        ],
      ),
    );
  }
}
