import 'package:app_news/apps/route/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../manage/service/firebase_service.dart';
import '../../../model/news_article.dart';
import '../../../widgets/card_custom.dart';

class AllArticleFeaturedPage extends StatelessWidget {
  const AllArticleFeaturedPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tin tức nổi bật",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              "Thư viện tin tức nổi bật ",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: StreamBuilder<List<NewsArticle>>(
          stream: FirebaseService().streamFeaturedArticles(),
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
              return const Text("Không có tin tức nổi bật nào");
            }
            var featuredArticles = snapshot.data!;
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: featuredArticles.length,
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  height: 13,
                  color: Colors.white,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                NewsArticle article = featuredArticles[index];
                return InkWell(
                  onTap: () {
                    Get.toNamed(RouterName.detailNewsPage,
                        arguments: article.id);
                  },
                  child: AspectRatio(
                    aspectRatio: 1 / 0.6,
                    child: CustomCard(
                      idCategory: article.idCategory,
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
