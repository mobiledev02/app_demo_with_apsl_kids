import 'package:get/get.dart';

import '../home_screen/home_controller.dart';
import '../next_screen/next_controller.dart';

class HomeScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
  }
}

class NextScreenBindings extends Bindings {
  @override
  void dependencies() {
    // In this demo created NextController just for binding purpose, there is no use of it
    Get.put<NextController>(NextController());
  }
}
