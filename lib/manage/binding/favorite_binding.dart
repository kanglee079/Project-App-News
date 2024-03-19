import 'package:app_news/manage/controller/favorite_news_controller.dart';
import 'package:get/get.dart';

class FavoriteBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoriteNewsController());
  }
}
