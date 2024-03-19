import 'package:app_news/manage/service/firebase_service.dart';
import 'package:app_news/model/news_article.dart';
import 'package:get/get.dart';

import '../../model/news_video.dart';

class ExploreController extends GetxController {
  var articlesThoiSu = <NewsArticle>[].obs;
  var articlesKinhDoanh = <NewsArticle>[].obs;
  var articlesKhoaHoc = <NewsArticle>[].obs;
  var videos = <NewsVideo>[].obs;

  final FirebaseService _firebaseService = FirebaseService();

  @override
  void onInit() {
    super.onInit();
    _subscribeToArticleStreams();
    loadVideos();
  }

  void _subscribeToArticleStreams() {
    _firebaseService.streamArticlesByCategory("1704454131640").listen((data) {
      articlesThoiSu.value = data;
    });

    _firebaseService.streamArticlesByCategory("1704457829058").listen((data) {
      articlesKinhDoanh.value = data;
    });

    _firebaseService.streamArticlesByCategory("1704457866841").listen((data) {
      articlesKhoaHoc.value = data;
    });
  }

  void loadVideos() {
    _firebaseService.streamVideo().listen((videoData) {
      videos.value = videoData;
    });
  }
}
