import 'package:app_demo_with_apsl_ads_kids/bindings/bindings.dart';
import 'package:get/get.dart';

import '../home_screen/home_scree.dart';
import '../next_screen/next_screen.dart';

mixin AppRoutes {
  static const homeScreen = "/";
  static const nextScreen = "/nextScreen";

  static final routes = [
    // Home Screen with binding
    GetPage(
      name: AppRoutes.homeScreen,
      page: () => const HomeScreen(),
    ),

    // Next Screen with binding
    GetPage(
      name: AppRoutes.nextScreen,
      page: () => const NextScreen(),
      binding: NextScreenBindings(),
    )
  ];
}
