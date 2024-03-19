import 'package:app_news/model/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/commet.dart';
import '../../model/info_user.dart';
import '../../model/news_article.dart';
import '../../model/news_video.dart';
import '../../model/replies.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static FirebaseFirestore get firestore => _firestore;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String get userId => _auth.currentUser?.uid ?? '';

  Future<void> addUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      DocumentReference docRef = _firestore.collection('users').doc(user.id);
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.update(user.toMap());
      } else {
        await docRef.set(user.toMap());
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        return UserModel.fromMap(data);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  //lấy user stream
  Stream<UserModel?> userStream(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return UserModel.fromMap(data);
      } else {
        return null;
      }
    }).handleError((error) {
      print(error);
      return null;
    });
  }

  //lấy tất cả category
  Stream<List<Category>> streamCategories() {
    return FirebaseFirestore.instance.collection('categories').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Category.fromMap(doc.data())).toList());
  }

  // hàm lấy bài viết nổi bật
  Stream<List<NewsArticle>> streamFeaturedArticles() {
    return FirebaseFirestore.instance
        .collection('articles')
        .where('isFeatured', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NewsArticle.fromMap(doc.data()))
            .toList());
  }

  //lấy tất cả bài viết
  Stream<List<NewsArticle>> streamArticles() {
    return _firestore.collection('articles').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => NewsArticle.fromMap(doc.data())).toList());
  }

  //lấy category bằng id
  Future<Category?> getCategoryById(String categoryId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .get();

      if (docSnapshot.exists) {
        return Category.fromMap(docSnapshot.data() as Map<String, dynamic>);
      } else {
        print("Không tìm thấy danh mục với ID: $categoryId");
        return null;
      }
    } catch (e) {
      print("Lỗi khi lấy thông tin danh mục: $e");
      return null;
    }
  }

  // lấy bài viết bằng id
  Stream<NewsArticle?> getArticleByIdStream(String articleId) {
    return _firestore
        .collection('articles')
        .doc(articleId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return NewsArticle.fromMap(snapshot.data() as Map<String, dynamic>);
      } else {
        print("Không tìm thấy bài viết với ID: $articleId");
        return null;
      }
    });
  }

  //lấy bài viết theo id category cố định
  Future<List<NewsArticle>> getArticlesByCategory(String categoryId) async {
    var querySnapshot = await _firestore
        .collection('articles')
        .where('idCategory', isEqualTo: categoryId)
        .get();

    return querySnapshot.docs
        .map((doc) => NewsArticle.fromMap(doc.data()))
        .toList();
  }

  //lấy tất cả bài viết dựa vào id category
  Stream<List<NewsArticle>> streamArticlesByCategory(String categoryId) {
    return _firestore
        .collection('articles')
        .where('idCategory', isEqualTo: categoryId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NewsArticle.fromMap(doc.data()))
            .toList());
  }

  Future<void> toggleFavorite(
      String userId, String articleId, bool isFavorite) async {
    // Cập nhật lượt yêu thích trong bài viết
    var articleRef =
        FirebaseFirestore.instance.collection('articles').doc(articleId);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      var articleSnapshot = await transaction.get(articleRef);
      if (articleSnapshot.exists) {
        int currentLikes = articleSnapshot.data()?['likes'] ?? 0;
        transaction.update(articleRef,
            {'likes': isFavorite ? currentLikes + 1 : currentLikes - 1});
      }
    });

    // Cập nhật danh sách yêu thích của người dùng
    var userFavoritesRef =
        FirebaseFirestore.instance.collection('userFavorites').doc(userId);
    var userFavoritesSnapshot = await userFavoritesRef.get();
    List<dynamic> favorites;
    if (userFavoritesSnapshot.exists) {
      favorites =
          userFavoritesSnapshot.data() != null ? ['favorites'] ?? [] : [];
    } else {
      favorites = [];
    }
    if (isFavorite) {
      favorites.add(articleId); // Thêm bài viết vào danh sách yêu thích
    } else {
      favorites.remove(articleId); // Xóa bài viết khỏi danh sách yêu thích
    }
    userFavoritesRef.set({'favorites': favorites});
  }

  //lấy danh sách yêu thích của user
  Future<List<NewsArticle>> getFavoriteNews(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorite_news')
          .get();

      List<NewsArticle> favoriteArticles = snapshot.docs
          .map((doc) => NewsArticle.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return favoriteArticles;
    } catch (e) {
      print('Error getting favorite news: $e');
      return [];
    }
  }

  //lấy danh sách video yêu thích của user
  Future<List<NewsVideo>> getFavoriteNewsVideo(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorite_news_video')
          .get();

      List<NewsVideo> favoriteNewsVideo = snapshot.docs
          .map((doc) => NewsVideo.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return favoriteNewsVideo;
    } catch (e) {
      print('Error getting favorite news: $e');
      return [];
    }
  }

  //xoá tin tức yêu thích
  Future<void> removeFavoriteNewsFromFirebase(
      String articleId, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorite_news')
        .doc(articleId)
        .delete();
  }

  // thêm bình luận
  Future<void> addComment(
    String articleId,
    String content,
  ) async {
    final comment = {
      'userId': userId,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .collection('comments')
        .add(comment);
  }

  // lấy comment
  Stream<List<Comment>> getComments(String articleId) {
    return _firestore
        .collection('articles')
        .doc(articleId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return Comment.fromMap(data);
      }).toList();
    });
  }

  // thêm reply comments
  Future<void> addReply(
    String articleId,
    String commentId,
    String content,
  ) async {
    final reply = {
      'userId': userId,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .add(reply);
  }

  // lấy replies
  Stream<List<Reply>> getReplies(String articleId, String commentId) {
    return _firestore
        .collection('articles')
        .doc(articleId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;
        return Reply.fromMap(data);
      }).toList();
    });
  }

  //Chức năng của video
  // Stream video
  Stream<List<NewsVideo>> streamVideo() {
    return _firestore.collection('videos').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => NewsVideo.fromMap(doc.data())).toList());
  }

  Future<List<NewsArticle>> searchArticles(String query) async {
    try {
      var querySnapshot = await _firestore
          .collection('articles')
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return querySnapshot.docs
          .map((doc) => NewsArticle.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error searching articles: $e');
      return [];
    }
  }

  void performSearch(String query) async {
    var articles = await FirebaseService().searchArticles(query);
  }

  Future<int> getUserCoins(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      int coins = userDoc['coins'] ?? 0;
      return coins;
    } catch (e) {
      print("Lỗi khi lấy số coin: $e");
      return 0;
    }
  }
}
