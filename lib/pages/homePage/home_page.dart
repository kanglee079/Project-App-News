import 'package:app_news/apps/route/route_name.dart';
import 'package:app_news/manage/controller/home_controller.dart';
import 'package:app_news/widgets/card_custom_2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../apps/helper/format_number.dart';
import '../../manage/service/exchange_rate_service.dart';
import '../../manage/service/firebase_service.dart';
import '../../model/current_exchange_price.dart';
import '../../model/news_article.dart';
import '../../widgets/card_custom.dart';
import '../../widgets/row_news.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Row(
            children: [
              Container(
                width: 50,
                height: 50,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(80),
                ),
                child: CachedNetworkImage(
                  imageUrl: controller.photoUrl.value,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(controller.greetingIcon.value,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(width: 5),
                      Text(
                        controller.greeting.value,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  Text(
                    controller.displayName.value,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Text(
                "Tỉ giá thế giới",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 5),
              FutureBuilder<CurrencyExchangeRate>(
                future: fetchExchangeRates(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingAnimationWidget.twistingDots(
                        leftDotColor: const Color(0xFF1A1A3F),
                        rightDotColor: const Color(0xFFEA3799),
                        size: 80,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    double usdToVnd = snapshot.data!.rates['VND']!;
                    double xauToVnd = snapshot.data!.rates['VND']! /
                        snapshot.data!.rates['XAU']!;
                    double xagToVnd = snapshot.data!.rates['VND']! /
                        snapshot.data!.rates['XAG']!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 25,
                              height: 25,
                              child: Image.asset(
                                "assets/image/backgroudImage/dollar.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '1 USD = ${formatCurrency(usdToVnd)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 25,
                              height: 25,
                              child: Image.asset(
                                "assets/image/backgroudImage/gold.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '1 Gold (XAU) = ${formatCurrency(xauToVnd)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 25,
                              height: 25,
                              child: Image.asset(
                                "assets/image/backgroudImage/silver.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '1 Silver (XAG) = ${formatCurrency(xagToVnd)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
              const SizedBox(height: 18),
              RowNews(
                title: "Tin tức nổi bật",
                ontap: controller.transToAllArticleFeaturedPage,
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 250,
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
                      itemCount: 5,
                      separatorBuilder: (BuildContext context, int index) {
                        return Container(
                          width: 13,
                          color: Colors.white,
                        );
                      },
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        NewsArticle article = featuredArticles[index];
                        return AspectRatio(
                          aspectRatio: 1.6 / 2,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(RouterName.detailNewsPage,
                                  arguments: article.id);
                            },
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
              const SizedBox(height: 23),
              Text(
                "Tin tức mới cho bạn",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              StreamBuilder<List<NewsArticle>>(
                stream: FirebaseService().streamArticles(),
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
                  var listArticles = snapshot.data!;
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listArticles.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(height: 15);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      NewsArticle article = listArticles[index];
                      return InkWell(
                        onTap: () {
                          Get.toNamed(RouterName.detailNewsPage,
                              arguments: article.id);
                        },
                        child: CustomCardSecond(
                          idCategory: article.idCategory,
                          title: article.title,
                          photoUrl: article.photoUrl,
                          date: article.dateTime,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
