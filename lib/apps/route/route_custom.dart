import 'package:app_news/apps/route/route_name.dart';
import 'package:app_news/manage/binding/donate_binding.dart';
import 'package:app_news/manage/binding/favorite_video_binding.dart';
import 'package:app_news/manage/binding/home_binding.dart';
import 'package:app_news/manage/binding/login_binding.dart';
import 'package:app_news/manage/binding/personal_binding.dart';
import 'package:app_news/manage/binding/register_binding.dart';
import 'package:app_news/manage/binding/splash_binding.dart';
import 'package:app_news/pages/SplashScreen/splash_screen.dart';
import 'package:app_news/pages/categoryPage/category_page.dart';
import 'package:app_news/pages/categoryPage/newsWithCategoryPage/news_with_category_page.dart';
import 'package:app_news/pages/detailNewsPage/detail_news_page.dart';
import 'package:app_news/pages/donatePage/donate_page.dart';
import 'package:app_news/pages/explorePage/explore_page.dart';
import 'package:app_news/pages/homePage/allArticleFeaturedPage/all_article_featured_page.dart';
import 'package:app_news/pages/homePage/home_page.dart';
import 'package:app_news/pages/loginPage/login_page.dart';
import 'package:app_news/pages/navigator_page.dart';
import 'package:app_news/pages/profilePage/component/profile_change_password_page.dart';
import 'package:app_news/pages/profilePage/profile_page.dart';
import 'package:app_news/pages/registerPage/register_page.dart';
import 'package:app_news/pages/savedPage/saved_page.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

import '../../manage/binding/explore_binding.dart';
import '../../manage/binding/favorite_binding.dart';
import '../../manage/middleware/auth_middleware.dart';

class RouterCustom {
  static List<GetPage> getPage = [
    GetPage(
      name: RouterName.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: RouterName.login,
      page: () => const LoginPage(),
      bindings: [
        LoginBinding(),
      ],
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
      middlewares: [
        AuthMiddlewares(),
      ],
    ),
    GetPage(
      name: RouterName.register,
      page: () => const RegisterPage(),
      bindings: [
        RegisterBinding(),
      ],
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 400),
      middlewares: [
        AuthMiddlewares(),
      ],
    ),
    GetPage(
      name: RouterName.navigatorPage,
      page: () => const NavigatorUserPage(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 200),
      bindings: [
        PersonalBinding(),
        HomeBinding(),
        ExploreBinding(),
        FavoriteBinding(),
        FavoriteVideoBinding(),
      ],
    ),
    GetPage(
      name: RouterName.homePage,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: RouterName.explorePage,
      page: () => const ExplorePage(),
      binding: ExploreBinding(),
    ),
    GetPage(
      name: RouterName.savedPage,
      page: () => const SavedPage(),
    ),
    GetPage(
      name: RouterName.profilePage,
      page: () => const ProfilePage(),
      binding: PersonalBinding(),
    ),
    GetPage(
      name: RouterName.categoryPage,
      page: () => const CategoryPage(),
    ),
    GetPage(
      name: RouterName.detailNewsPage,
      page: () => const DetailNewsPage(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 270),
      binding: FavoriteBinding(),
    ),
    GetPage(
      name: RouterName.newsWithCategoryPage,
      page: () => const NewsWithCategoryPage(),
    ),
    GetPage(
      name: RouterName.allArticleFeaturedPage,
      page: () => const AllArticleFeaturedPage(),
    ),
    GetPage(
      name: RouterName.profileChangePasswordPage,
      page: () => const PersonalChangePasswordPage(),
    ),
    GetPage(
      name: RouterName.donatePage,
      page: () => DonatePage(),
      binding: DonateBinding(),
    ),
  ];
}
