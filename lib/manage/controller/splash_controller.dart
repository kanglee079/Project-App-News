import 'package:app_news/apps/route/route_name.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  void transToLoginPage() {
    Get.offAndToNamed(RouterName.login);
  }
}
