import 'package:app_news/manage/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/button_custom.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                ),
              ),
              child: Image.asset(
                "assets/image/backgroudImage/image1.png",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xffF8F8FA),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                ),
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 17,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "XiKang News",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      "Khám phá thế giới qua tin tức",
                      style: Theme.of(context).textTheme.labelLarge,
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    ),
                    Text(
                      "Đắm chìm trong thế giới cập nhật theo thời gian thực và những câu chuyện hấp dẫn.",
                      style: Theme.of(context).textTheme.labelMedium,
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                    ),
                    ButtonCustom(
                      onTap: () {
                        controller.transToLoginPage();
                      },
                      backgroundColor: Theme.of(context).primaryColor,
                      textStyle: Theme.of(context).textTheme.titleMedium,
                      textButton: "Bắt Đầu",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Bạn đã có tài khoản?"),
                        TextButton(
                          onPressed: () {
                            controller.transToLoginPage();
                          },
                          child: Text(
                            "Đăng nhập ngay",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
