import 'package:app_news/model/news_video.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../apps/helper/show_toast.dart';
import '../state/news_video_favorite.dart';
import '../store/user_store.dart';

class FavoriteNewsVideoController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final state = FavoriteNewsVideoState();
  final idUser = UserStore.to.userInfo.id;

  @override
  void onReady() {
    super.onReady();
    loadFavoriteNewsVideo();
  }

  bool isNewsVideoFavorite(String videoId) {
    return state.listFavoriteNews.any((video) => video.id == videoId);
  }

  Future<void> updateLikes(String videoId, bool isLiked) async {
    var videoRef = _firestore.collection('videos').doc(videoId);
    return _firestore.runTransaction((transaction) async {
      var videoSnapshot = await transaction.get(videoRef);
      if (videoSnapshot.exists) {
        var currentLikes = videoSnapshot.data()?['likes'] ?? 0;
        transaction.update(videoRef, {
          'likes': isLiked ? currentLikes + 1 : currentLikes - 1,
        });
      }
    });
  }

  void toggleFavoriteBook(NewsVideo video) {
    bool isLiked = isNewsVideoFavorite(video.id);
    if (isLiked) {
      removeFavoriteNewsVideoFromFirebase(video.id);
      updateLikes(video.id, false);
      showToastError("Đã xoá yêu thích bài viết!");
    } else {
      addFavoriteNewsVideoToFirebase(video);
      updateLikes(video.id, true);
      showToastSuccess("Đã yêu thích bài viết!");
    }
  }

  Future<void> loadFavoriteNewsVideo() async {
    try {
      var snapshot = await _firestore
          .collection("users")
          .doc(idUser)
          .collection('favorite_news_video')
          .get();
      var favoriteNewsVideo =
          snapshot.docs.map((doc) => NewsVideo.fromMap(doc.data())).toList();
      state.listFavoriteNews.clear();
      state.listFavoriteNews.addAll(favoriteNewsVideo);
    } catch (e) {
      print("Error loading favorite books: $e");
    }
  }

  Future<void> addFavoriteNewsVideoToFirebase(NewsVideo video) async {
    if (video.id.isNotEmpty && !isNewsVideoFavorite(video.id)) {
      await _firestore
          .collection("users")
          .doc(idUser)
          .collection('favorite_news_video')
          .doc(video.id)
          .set(video.toMap());
      state.listFavoriteNews.add(video);
    } else {
      print("Invalid book data or already in favorites");
    }
  }

  Future<void> removeFavoriteNewsVideoFromFirebase(String videoId) async {
    if (isNewsVideoFavorite(videoId)) {
      await _firestore
          .collection("users")
          .doc(idUser)
          .collection('favorite_news_video')
          .doc(videoId)
          .delete();
      state.listFavoriteNews.removeWhere((video) => video.id == videoId);
    } else {
      print("News not in favorites");
    }
  }
}
