import 'package:app_news/manage/controller/explore_controller.dart';
import 'package:get/get.dart';

class ExploreBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ExploreController());
  }
}
