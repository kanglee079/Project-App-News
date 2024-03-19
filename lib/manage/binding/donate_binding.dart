import 'package:app_news/manage/controller/donate_controller.dart';
import 'package:get/get.dart';

class DonateBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DonateController());
  }
}
