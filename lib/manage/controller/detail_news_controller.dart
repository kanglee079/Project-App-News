import 'package:app_news/manage/service/firebase_service.dart';
import 'package:get/get.dart';

import '../../model/category.dart';
import '../../model/commet.dart';
import '../../model/info_user.dart';
import '../../model/news_article.dart';
import '../../model/replies.dart';
import '../store/user_store.dart';

class DetailNewsController extends GetxController {
  final FirebaseService firebaseService;
  Rx<NewsArticle?> article = Rx<NewsArticle?>(null);
  Rx<Category?> category = Rx<Category?>(null);
  String articleId;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  final idUser = UserStore.to.userInfo.id;
  var showReplyInput = <String, RxBool>{}.obs;
  RxList<Comment> comments = RxList<Comment>();
  RxMap<String, List<Reply>> replies = RxMap<String, List<Reply>>();
  RxMap<String, UserModel> users = RxMap<String, UserModel>();
  var textSize = 14.0.obs;

  DetailNewsController(
      {required this.firebaseService, required this.articleId});

  @override
  void onInit() {
    super.onInit();
    fetchCommentsAndReplies();
    fetchArticle();
  }

  void updateTextSize(double newSize) {
    textSize.value = newSize;
  }

  void fetchArticle() {
    isLoading(true);
    firebaseService.getArticleByIdStream(articleId).listen((articleData) {
      article.value = articleData;
      if (articleData != null && articleData.idCategory.isNotEmpty) {
        fetchCategory(articleData.idCategory);
      }
    }, onError: (error) {
      errorMessage(error.toString());
      isLoading(false);
    });
  }

  void fetchCategory(String categoryId) async {
    try {
      var categoryData = await firebaseService.getCategoryById(categoryId);
      category.value = categoryData;
      isLoading(false);
    } catch (e) {
      errorMessage(e.toString());
      isLoading(false);
    }
  }

  void fetchCommentsAndReplies() {
    firebaseService.getComments(articleId).listen((commentData) {
      comments.value = commentData;
      for (var comment in commentData) {
        fetchUser(comment.userId);
        fetchReplies(comment.id);
      }
      update();
    }, onError: (error) {
      errorMessage(error.toString());
    });
  }

  void fetchReplies(String commentId) {
    firebaseService.getReplies(articleId, commentId).listen((replyData) {
      replies[commentId] = replyData;
      for (var reply in replyData) {
        fetchUser(reply.userId);
      }
      update();
    }, onError: (error) {
      errorMessage(error.toString());
    });
  }

  void fetchUser(String userId) {
    if (!users.containsKey(userId)) {
      firebaseService.userStream(userId).listen((userData) {
        users[userId] = userData!;
      }, onError: (error) {
        errorMessage(error.toString());
      });
    }
  }

  void addComment(String content) {
    firebaseService.addComment(articleId, content);
    fetchCommentsAndReplies();
  }

  void addReply(String commentId, String content) {
    firebaseService.addReply(articleId, commentId, content).then((_) {
      // Fetch only the replies for the specific comment
      fetchRepliesForComment(commentId);
    }).catchError((error) {
      errorMessage(error.toString());
    });
  }

  void fetchRepliesForComment(String commentId) {
    firebaseService.getReplies(articleId, commentId).listen((replyData) {
      replies[commentId] = replyData;
      update();
    }, onError: (error) {
      errorMessage(error.toString());
    });
  }

  // void addReply(String commentId, String content) {
  //   firebaseService.addReply(articleId, commentId, content);
  //   fetchCommentsAndReplies();
  // }

  void toggleReplyInput(String commentId) {
    if (!showReplyInput.containsKey(commentId)) {
      showReplyInput[commentId] = false.obs;
    }
    showReplyInput[commentId]!.value = !showReplyInput[commentId]!.value;
  }
}
