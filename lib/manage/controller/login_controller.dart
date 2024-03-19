import 'package:app_news/apps/route/route_name.dart';
import 'package:app_news/manage/service/auth_service.dart';
import 'package:app_news/manage/service/firebase_service.dart';
import 'package:app_news/manage/store/user_store.dart';
import 'package:app_news/model/info_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../apps/helper/show_toast.dart';

class LoginController extends GetxController {
  late GlobalKey<FormState> keyLoginForm;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final RxBool isChecked = false.obs;
  final RxBool _loading = false.obs;

  bool get loading => _loading.value;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    keyLoginForm = GlobalKey<FormState>();
    passwordController = TextEditingController();
  }

  void toggleCheckbox(bool? value) {
    isChecked.value = value!;
  }

  void login() async {
    if (loading) return;
    _loading.value = true;

    try {
      User? user = await AuthService.to.signInWithEmailPassword(
          emailController.text, passwordController.text);

      if (user != null) {
        UserModel? userModel = await FirebaseService().getUser(user.uid);

        if (userModel != null) {
          UserStore.to.login(userModel);
        }

        showToastSuccess('Đăng nhập thành công');

        // StoreService.to.setString(MyKey.TOKEN_USER, user.uid);
      } else {
        showToastError('Thông tin đăng nhập không chính xác');
      }
    } catch (e) {
      showToastError(e.toString());
    } finally {
      _loading.value = false;
    }
  }

  void loginWithGoogle() async {
    if (loading) return;
    _loading.value = true;

    try {
      User? user = await AuthService.to.signInWithGoogle();

      if (user != null) {
        UserModel? userModel = await FirebaseService().getUser(user.uid);

        if (userModel != null) {
          UserStore.to.login(userModel);
        }

        showToastSuccess('Đăng nhập bằng Google thành công');

        // StoreService.to.setString(MyKey.TOKEN_USER, user.uid);
      } else {
        showToastError('Đăng nhập thất bại');
      }
    } catch (e) {
      showToastError(e.toString());
      print(e.toString());
    } finally {
      _loading.value = false;
    }
    keyLoginForm = GlobalKey<FormState>();
  }

  void forgotPassword() {
    // Thêm logic quên mật khẩu ở đây
  }

  void register() {
    Get.offAndToNamed(RouterName.register);
  }
}
