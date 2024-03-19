import 'package:app_news/manage/service/firebase_service.dart';
import 'package:app_news/model/news_article.dart';
import 'package:app_news/model/news_video.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../store/user_store.dart';

class SavedPageController extends GetxController {
  final FirebaseService firebaseService;
  RxList<NewsArticle> favoriteNews = RxList<NewsArticle>();
  RxList<NewsVideo> favoriteNewsVideo = RxList<NewsVideo>();
  final idUser = UserStore.to.userInfo.id;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SavedPageController({required this.firebaseService});

  @override
  void onReady() {
    super.onReady();
    loadFavoriteNews();
    loadFavoriteNewsVideo();
  }

  void loadFavoriteNews() async {
    var articles = await firebaseService.getFavoriteNews(idUser!);
    favoriteNews.assignAll(articles);
  }

  void loadFavoriteNewsVideo() async {
    var videos = await firebaseService.getFavoriteNewsVideo(idUser!);
    favoriteNewsVideo.assignAll(videos);
  }

  Future<void> updateLikes(String articleId, bool isLiked) async {
    var articleRef = _firestore.collection('articles').doc(articleId);
    return _firestore.runTransaction((transaction) async {
      var articleSnapshot = await transaction.get(articleRef);
      if (articleSnapshot.exists) {
        var currentLikes = articleSnapshot.data()?['likes'] ?? 0;
        transaction.update(articleRef, {
          'likes': isLiked ? currentLikes + 1 : currentLikes - 1,
        });
      }
    });
  }

  Future<void> updateLikesVideo(String videoId, bool isLiked) async {
    var articleRef = _firestore.collection('videos').doc(videoId);
    return _firestore.runTransaction((transaction) async {
      var articleSnapshot = await transaction.get(articleRef);
      if (articleSnapshot.exists) {
        var currentLikes = articleSnapshot.data()?['likes'] ?? 0;
        transaction.update(articleRef, {
          'likes': isLiked ? currentLikes + 1 : currentLikes - 1,
        });
      }
    });
  }

  void removeFavoriteNews(String articleId) async {
    try {
      await FirebaseService()
          .removeFavoriteNewsFromFirebase(articleId, idUser!);
      favoriteNews.removeWhere((article) => article.id == articleId);
      updateLikes(articleId, false);
    } catch (e) {
      print('Error removing favorite news: $e');
    }
  }

  void removeFavoriteNewsVideo(String videoId) async {
    try {
      await FirebaseService().removeFavoriteNewsFromFirebase(videoId, idUser!);
      favoriteNewsVideo.removeWhere((video) => video.id == videoId);
      updateLikesVideo(videoId, false);
    } catch (e) {
      print('Error removing favorite news: $e');
    }
  }
}
