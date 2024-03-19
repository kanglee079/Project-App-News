import 'package:app_news/apps/route/route_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../apps/helper/show_toast.dart';
import '../../model/info_user.dart';
import '../service/auth_service.dart';
import '../service/firebase_service.dart';
import '../store/user_store.dart';

class RegisterController extends GetxController {
  late GlobalKey<FormState> keyRegisterForm;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController displayNameController;
  final RxBool _loading = false.obs;

  bool get loading => _loading.value;

  @override
  void onInit() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    displayNameController = TextEditingController();
    keyRegisterForm = GlobalKey<FormState>();
    super.onInit();
  }

  @override
  void onClose() {
    displayNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void register() async {
    if (loading) return;
    _loading.value = true;

    if (passwordController.text != confirmPasswordController.text) {
      showToastError('Mật khẩu xác nhận không khớp');
      _loading.value = false;
      return;
    }

    try {
      User? user = await AuthService.to.signUpWithEmailPassword(
        emailController.text,
        passwordController.text,
        displayNameController.text,
      );

      if (user != null) {
        UserModel? userModel = await FirebaseService().getUser(user.uid);

        if (userModel != null) {
          UserStore.to.login(userModel);
          // StoreService.to.setString(MyKey.TOKEN_USER, user.uid);
        }
        showToastSuccess('Đăng kí thành công');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      print(e);
    } finally {
      _loading.value = false;
    }
    keyRegisterForm = GlobalKey<FormState>();
  }

  void backToLogin() {
    Get.offAndToNamed(RouterName.login);
  }
}
