import 'package:app_news/model/news_article.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ArticleFeaturedState {
  RxList<NewsArticle> featuredArticles = <NewsArticle>[].obs;
}
