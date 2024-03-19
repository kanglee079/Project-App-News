import 'package:app_news/manage/controller/register_controller.dart';
import 'package:app_news/widgets/button_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/form_register_widget.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: controller.backToLogin,
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          title: const Text("Đăng Ký"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Tạo Tài Khoản Mới",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 25),
                FormRegisterWidget(
                  keyRegisterForm: controller.keyRegisterForm,
                  emailController: controller.emailController,
                  passwordController: controller.passwordController,
                  confirmPasswordController:
                      controller.confirmPasswordController,
                  displayNameController: controller.displayNameController,
                ),
                const SizedBox(height: 20),
                Obx(
                  () => ButtonCustom(
                    onloading: controller.loading,
                    onTap: () {
                      controller.register();
                    },
                    backgroundColor: Theme.of(context).primaryColor,
                    textButton: "Đăng Ký",
                    textStyle: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 10),
                // Các widget khác nếu cần
              ],
            ),
          ),
        ),
      ),
    );
  }
}
