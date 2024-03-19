import 'package:app_news/manage/controller/detail_news_controller.dart';
import 'package:app_news/manage/controller/favorite_news_controller.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

import '../../apps/helper/show_toast.dart';
import '../../manage/service/firebase_service.dart';
import '../../model/news_article.dart';

class DetailNewsPage extends StatefulWidget {
  const DetailNewsPage({super.key});

  @override
  State<DetailNewsPage> createState() => _DetailNewsPageState();
}

class _DetailNewsPageState extends State<DetailNewsPage> {
  final TextEditingController commentController = TextEditingController();
  final TextEditingController replyController = TextEditingController();
  final Map<String, bool> showReplyInput = {};
  final controllerFavorite = Get.find<FavoriteNewsController>();
  String articleId = Get.arguments;

  final DetailNewsController controllerDetailNews =
      Get.put(DetailNewsController(
    firebaseService: FirebaseService(),
    articleId: Get.arguments,
  ));

  void showTextSizeAdjuster(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Obx(
          () => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                    "Kích cỡ nội dung: ${controllerDetailNews.textSize.value.toStringAsFixed(1)}"),
                Slider(
                  min: 10.0,
                  max: 30.0,
                  divisions: 20,
                  value: controllerDetailNews.textSize.value,
                  onChanged: (value) {
                    controllerDetailNews.updateTextSize(value);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Chi tiết tin tức",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
            leading: const BackButton(color: Colors.black),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.text_format, color: Colors.black),
                onPressed: () => showTextSizeAdjuster(context),
              ),
              const SizedBox(width: 15)
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                        imageUrl: controllerDetailNews
                                .article.value?.photoUrl ??
                            "https://img.ws.mms.shopee.vn/96fdcd65ef075b128f36c289a62723db"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: Obx(
                                () {
                                  String categoryName = controllerDetailNews
                                          .category.value?.name ??
                                      "Loading...";
                                  return Text(
                                    categoryName,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  );
                                },
                              ),
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          badges.Badge(
                            badgeStyle: const badges.BadgeStyle(),
                            badgeContent: Text(
                              controllerDetailNews.article.value?.likes
                                      .toString() ??
                                  "0",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                            child: const Icon(Icons.favorite),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        controllerDetailNews.article.value?.title ?? "Default",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Tác giả: ${controllerDetailNews.article.value?.authorName ?? "null"}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        DateFormat('dd/MM/yyyy')
                            .format(
                                controllerDetailNews.article.value?.dateTime ??
                                    DateTime(0))
                            .toString(),
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        controllerDetailNews.article.value?.content ?? "null",
                        style: TextStyle(
                          color: const Color(0xff343434),
                          fontSize: controllerDetailNews.textSize.value,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Bình luận"),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 20, left: 20, bottom: 30),
                  child: Obx(
                    () => ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(
                          height: 30,
                          color: Colors.grey,
                        );
                      },
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controllerDetailNews.comments.length,
                      itemBuilder: (context, index) {
                        final comment = controllerDetailNews.comments[index];
                        final user = controllerDetailNews.users[comment.userId];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Image.network(
                                      user?.photoUrl ??
                                          "https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w1200/2023/10/free-images.jpg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        bottom: 10,
                                        left: 10,
                                        right: 20,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(user?.displayName ?? "Default"),
                                          Text(
                                            comment.content,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Obx(
                                    () {
                                      if (controllerDetailNews
                                              .showReplyInput[comment.id]
                                              ?.value ??
                                          false) {
                                        return IconButton(
                                          onPressed: () => controllerDetailNews
                                              .toggleReplyInput(comment.id),
                                          icon: const Icon(Icons.close),
                                        );
                                      }
                                      return TextButton(
                                        onPressed: () => controllerDetailNews
                                            .toggleReplyInput(comment.id),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7, vertical: 2),
                                            child: Text(
                                              'Reply',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Obx(
                              () {
                                if (controllerDetailNews
                                        .showReplyInput[comment.id]?.value ??
                                    false) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: TextField(
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                      controller: replyController,
                                      decoration: InputDecoration(
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                        hintText: "Nhập trả lời của bạn...",
                                        suffixIcon: IconButton(
                                          icon: const Icon(Icons.send),
                                          onPressed: () {
                                            String replyText =
                                                replyController.text;
                                            try {
                                              if (replyText.isNotEmpty) {
                                                controllerDetailNews.addReply(
                                                  comment.id,
                                                  replyText,
                                                );
                                                replyController.clear();
                                                controllerDetailNews
                                                        .showReplyInput[
                                                    comment.id] = false.obs;
                                              } else {
                                                showToastError(
                                                    "Chưa nhập nội dung");
                                              }
                                            } catch (e) {}
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                            if (controllerDetailNews.replies
                                .containsKey(comment.id))
                              Obx(
                                () => ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controllerDetailNews
                                      .replies[comment.id]?.length,
                                  itemBuilder: (context, replyIndex) {
                                    final reply = controllerDetailNews
                                        .replies[comment.id]![replyIndex];
                                    final replyUser = controllerDetailNews
                                        .users[reply.userId];

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 40),
                                          Container(
                                            width: 50,
                                            height: 50,
                                            clipBehavior: Clip.hardEdge,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Image.network(
                                              replyUser!.photoUrl ??
                                                  "https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w1200/2023/10/free-images.jpg",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8,
                                                bottom: 10,
                                                left: 10,
                                                right: 20,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(replyUser.displayName!),
                                                  Text(
                                                    reply.content,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: BottomAppBar(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      style: Theme.of(context).textTheme.bodySmall,
                      decoration: InputDecoration(
                        hintText: "Thêm bình luận...",
                        labelStyle: Theme.of(context).textTheme.bodySmall,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            try {
                              if (commentController.text.isNotEmpty) {
                                controllerDetailNews
                                    .addComment(commentController.text);
                                showToastSuccess("Đã thêm bình luận");
                                commentController.clear();
                              } else {
                                showToastError("Chưa có nội dung");
                              }
                            } catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () {
                      bool isLiked =
                          controllerFavorite.isArticleFavorite(articleId);
                      return LikeButton(
                        size: 30,
                        isLiked: isLiked,
                        onTap: (isLiked) async {
                          NewsArticle likeArticle = NewsArticle(
                            id: controllerDetailNews.article.value!.id,
                            idCategory:
                                controllerDetailNews.article.value!.idCategory,
                            isFeatured:
                                controllerDetailNews.article.value!.isFeatured,
                            title: controllerDetailNews.article.value!.title,
                            authorName:
                                controllerDetailNews.article.value!.authorName,
                            dateTime:
                                controllerDetailNews.article.value!.dateTime,
                            description:
                                controllerDetailNews.article.value!.description,
                            content:
                                controllerDetailNews.article.value!.content,
                            photoUrl:
                                controllerDetailNews.article.value!.photoUrl,
                            likes: controllerDetailNews.article.value!.likes,
                          );
                          controllerFavorite.toggleFavoriteBook(likeArticle);
                          return !isLiked;
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
