import 'package:app_news/apps/route/route_name.dart';
import 'package:app_news/manage/controller/personal_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/item_personal.dart';

class ProfilePage extends GetView<PersonalController> {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: controller.updateProfilePicture,
                      child: Obx(
                        () => Container(
                          width: 100,
                          height: 100,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
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
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 21),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            "Tên: ${controller.displayName.value}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        "Tổng quan",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                ItemsPersonal(
                  icon: Icons.attach_money,
                  nameItem: "Ủng hộ chúng tôi tại đây",
                  ontap: () {
                    Get.toNamed(RouterName.donatePage);
                  },
                ),
                ItemsPersonal(
                  icon: Icons.security_outlined,
                  nameItem: "Bảo mật",
                  ontap: () {
                    Get.toNamed(RouterName.profileChangePasswordPage);
                  },
                ),
                const ItemsPersonal(
                  icon: Icons.dark_mode,
                  nameItem: "Chế độ tối",
                  isSwitchItem: true,
                ),
                ItemsPersonal(
                  icon: Icons.logout,
                  nameItem: "Đăng xuất",
                  ontap: controller.logout,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
