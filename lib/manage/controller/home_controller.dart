import 'package:app_news/apps/route/route_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/info_user.dart';
import '../store/user_store.dart';

class HomeController extends GetxController {
  UserModel userInfo = UserStore.to.userInfo;
  RxString displayName = UserStore.to.userName.obs;
  RxString emailUser = UserStore.to.userEmail.obs;
  RxString photoUrl = UserStore.to.photoUrl.obs;
  RxString greeting = ''.obs;
  Rx<IconData> greetingIcon = Rx(Icons.wb_sunny);

  @override
  void onInit() {
    super.onInit();
    determineGreeting();
  }

  void determineGreeting() {
    var hour = DateTime.now().hour;
    if (hour >= 0 && hour < 12) {
      greeting.value = "Chào buổi sáng";
      greetingIcon.value = Icons.wb_sunny;
    } else if (hour >= 12 && hour < 18) {
      greeting.value = "Chào buổi chiều";
      greetingIcon.value = Icons.wb_cloudy;
    } else {
      greeting.value = "Chào buổi tối";
      greetingIcon.value = Icons.nights_stay;
    }
  }

  void transToAllArticleFeaturedPage() {
    Get.toNamed(RouterName.allArticleFeaturedPage);
  }
}
