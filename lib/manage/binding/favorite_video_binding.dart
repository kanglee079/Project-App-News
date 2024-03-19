import 'package:app_news/manage/controller/favorite_news_video_controller.dart';
import 'package:get/get.dart';

class FavoriteVideoBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoriteNewsVideoController());
  }
}
