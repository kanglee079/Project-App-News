import 'package:app_news/manage/service/firebase_service.dart';
import 'package:app_news/model/news_article.dart';
import 'package:app_news/widgets/card_custom_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../apps/route/route_name.dart';

class NewsWithCategoryPage extends StatelessWidget {
  const NewsWithCategoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    var data = Get.arguments as Map;
    var categoryId = data['categoryId'];
    var categoryName = data['categoryName'];
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bài viết theo danh mục",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              categoryName,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: StreamBuilder<List<NewsArticle>>(
          stream: FirebaseService().streamArticlesByCategory(categoryId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.twistingDots(
                  leftDotColor: const Color(0xFF1A1A3F),
                  rightDotColor: const Color(0xFFEA3799),
                  size: 100,
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Không có tin tức nào"));
            }
            List<NewsArticle> listArticle = snapshot.data!;
            return ListView.separated(
              itemCount: listArticle.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(height: 20, color: Colors.white);
              },
              itemBuilder: (BuildContext context, int index) {
                NewsArticle article = listArticle[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(RouterName.detailNewsPage,
                          arguments: article.id);
                    },
                    child: CustomCardSecond(
                      idCategory: categoryId,
                      title: article.title,
                      photoUrl: article.photoUrl,
                      date: article.dateTime,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
