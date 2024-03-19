import 'package:app_news/manage/controller/personal_controller.dart';
import 'package:get/get.dart';

class PersonalBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PersonalController());
  }
}
