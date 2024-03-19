import 'package:app_news/manage/controller/login_controller.dart';
import 'package:app_news/widgets/button_custom.dart';
import 'package:app_news/widgets/button_custom_social.dart';
import 'package:app_news/widgets/form_login_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Chào Mừng Trở Lại!",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 5),
                Text(
                  "Đăng nhập để truy cập hành trình tin tức được cá nhân hóa",
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                FormLoginWidget(
                  keyLoginForm: controller.keyLoginForm,
                  emailController: controller.emailController,
                  passwordController: controller.passwordController,
                ),
                const SizedBox(height: 30),
                // Row(
                //   children: [
                //     Expanded(
                //       child: Row(
                //         children: [
                //           Obx(() => Checkbox(
                //                 checkColor: Colors.white,
                //                 fillColor: MaterialStateProperty.all(
                //                   controller.isChecked.value
                //                       ? Colors.blue
                //                       : Colors.white,
                //                 ),
                //                 value: controller.isChecked.value,
                //                 onChanged: controller.toggleCheckbox,
                //               )),
                //           Text(
                //             "Giữ đăng nhập",
                //             style: Theme.of(context).textTheme.bodySmall,
                //           ),
                //         ],
                //       ),
                //     ),
                //     TextButton(
                //       onPressed: controller.forgotPassword,
                //       child: Text(
                //         "Quên mật khẩu?",
                //         style: Theme.of(context).textTheme.labelSmall,
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 5),
                Obx(
                  () => ButtonCustom(
                    onloading: controller.loading,
                    onTap: controller.login,
                    backgroundColor: Theme.of(context).primaryColor,
                    textStyle: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Nhấn"),
                    TextButton(
                      onPressed: controller.register,
                      child: Text(
                        "đăng kí",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16),
                      ),
                    ),
                    const Text("nếu chưa có tài khoản"),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        decoration: const BoxDecoration(color: Colors.grey),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("Hoặc tiếp tục với"),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        decoration: const BoxDecoration(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ButtonCustomSocial(
                  onTap: controller.loginWithGoogle,
                  textButton: "Đăng nhập Google",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
