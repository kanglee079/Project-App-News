import 'package:app_news/model/news_article.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../apps/helper/show_toast.dart';
import '../state/news_favorite_state.dart';
import '../store/user_store.dart';

class FavoriteNewsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final state = FavoriteNewsState();
  final idUser = UserStore.to.userInfo.id;

  @override
  void onReady() {
    super.onReady();
    loadFavoriteNews();
  }

  bool isArticleFavorite(String articleId) {
    return state.listFavoriteNews.any((article) => article.id == articleId);
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

  void toggleFavoriteBook(NewsArticle article) {
    bool isLiked = isArticleFavorite(article.id);
    if (isLiked) {
      removeFavoriteNewsFromFirebase(article.id);
      updateLikes(article.id, false);
      showToastError("Đã xoá yêu thích bài viết!");
    } else {
      addFavoriteNewsToFirebase(article);
      updateLikes(article.id, true);
      showToastSuccess("Đã yêu thích bài viết!");
    }
  }

  Future<void> loadFavoriteNews() async {
    try {
      var snapshot = await _firestore
          .collection("users")
          .doc(idUser)
          .collection('favorite_news')
          .get();
      var favoriteNews =
          snapshot.docs.map((doc) => NewsArticle.fromMap(doc.data())).toList();
      state.listFavoriteNews.clear();
      state.listFavoriteNews.addAll(favoriteNews);
    } catch (e) {
      print("Error loading favorite books: $e");
    }
  }

  Future<void> addFavoriteNewsToFirebase(NewsArticle article) async {
    if (article.id.isNotEmpty && !isArticleFavorite(article.id)) {
      await _firestore
          .collection("users")
          .doc(idUser)
          .collection('favorite_news')
          .doc(article.id)
          .set(article.toMap());
      state.listFavoriteNews.add(article);
    } else {
      print("Invalid book data or already in favorites");
    }
  }

  Future<void> removeFavoriteNewsFromFirebase(String articleId) async {
    if (isArticleFavorite(articleId)) {
      await _firestore
          .collection("users")
          .doc(idUser)
          .collection('favorite_news')
          .doc(articleId)
          .delete();
      state.listFavoriteNews.removeWhere((article) => article.id == articleId);
    } else {
      print("News not in favorites");
    }
  }
}
