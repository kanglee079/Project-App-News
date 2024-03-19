import 'package:app_news/model/news_article.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class FavoriteNewsState {
  RxList<NewsArticle> listFavoriteNews = <NewsArticle>[].obs;
}
