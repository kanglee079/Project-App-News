import 'dart:io';

import 'package:app_news/manage/state/personal_state.dart';
import 'package:app_news/manage/store/user_store.dart';
import 'package:app_news/model/info_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../apps/route/route_name.dart';

class PersonalController extends GetxController {
  final state = PersonalState();

  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Hủy',
              style: TextStyle(
                color: Color(0xff343434),
                fontSize: 18,
              ),
            ),
            onPressed: () => Get.back(), // Đóng dialog
          ),
          TextButton(
            child: const Text(
              'Đồng ý',
              style: TextStyle(
                color: Color(0xff343434),
                fontSize: 18,
              ),
            ),
            onPressed: () {
              UserStore.to.logout().then((value) {
                Get.offAndToNamed(RouterName.login);
              });
              Get.back(); // Đóng dialog sau khi chọn đăng xuất
            },
          ),
        ],
      ),
    );
  }

  UserModel userInfo = UserStore.to.userInfo;
  RxString displayName = UserStore.to.userName.obs;
  RxString emailUser = UserStore.to.userEmail.obs;
  RxString photoUrl = UserStore.to.photoUrl.obs;

  Future<void> updateProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);
      String filePath =
          'user_images/${userInfo.id}/${DateTime.now().millisecondsSinceEpoch}_${image.name}';

      try {
        TaskSnapshot snapshot =
            await FirebaseStorage.instance.ref().child(filePath).putFile(file);

        String downloadUrl = await snapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userInfo.id)
            .update({'photoUrl': downloadUrl});

        UserStore.to.updateUserPhotoUrl(downloadUrl);
        photoUrl.value = downloadUrl;
      } catch (e) {}
    }
  }
}
