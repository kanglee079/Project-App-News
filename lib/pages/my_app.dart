import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../apps/route/route_custom.dart';
import '../apps/route/route_name.dart';
import '../manage/controller/theme_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());
    return Obx(
      () => GetMaterialApp(
        theme: themeController.themeData,
        initialRoute: RouterName.splash,
        getPages: RouterCustom.getPage,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
