import 'package:app_news/firebase_options.dart';
import 'package:app_news/manage/controller/theme_controller.dart';
import 'package:app_news/pages/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'manage/service/auth_service.dart';
import 'manage/service/store_service.dart';
import 'manage/store/user_store.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // name: 'demoapp',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.lazyPut<ThemeController>(() => ThemeController());
  Get.lazyPut(() => AuthService());
  await Get.putAsync(() => StoreService().init());
  Get.put(UserStore());
  runApp(const MyApp());
}
