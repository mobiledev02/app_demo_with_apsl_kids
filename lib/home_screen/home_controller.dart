import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt navigationCount = 0.obs;

  void incrementNavigationCount() {
    navigationCount.value++;
  }

  get navigationCountValue => navigationCount.value;
}
