import 'package:app_news/manage/service/auth_service.dart';
import 'package:flutter/material.dart';

import '../../../apps/helper/show_toast.dart';
import '../../../widgets/button_custom.dart';
import '../../../widgets/text_form_field.dart';

class PersonalChangePasswordPage extends StatefulWidget {
  const PersonalChangePasswordPage({super.key});

  @override
  State<PersonalChangePasswordPage> createState() =>
      _PersonalChangePasswordPageState();
}

class _PersonalChangePasswordPageState
    extends State<PersonalChangePasswordPage> {
  final TextEditingController currientPassword = TextEditingController();
  final TextEditingController newsPassword = TextEditingController();
  final TextEditingController againNewsPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Đổi mật khẩu",
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mật khẩu hiện tại",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 10),
                    TextFormCustom(
                      controller: currientPassword,
                      isPassword: true,
                      hintText: "Nhập mật khẩu hiện tại",
                      iconPrefix: Icons.password,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Mật khẩu mới",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 10),
                    TextFormCustom(
                      controller: newsPassword,
                      hintText: "Nhập mật khẩu mới",
                      isPassword: true,
                      iconPrefix: Icons.password_outlined,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Nhập lại mật khẩu mới",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 10),
                    TextFormCustom(
                      controller: againNewsPassword,
                      isPassword: true,
                      hintText: "Nhập nhập lại mật khẩu mới",
                      iconPrefix: Icons.password_outlined,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: ButtonCustom(
            backgroundColor: Theme.of(context).cardColor,
            textButton: "Đổi mật khẩu",
            textStyle: Theme.of(context).textTheme.displayMedium,
            onTap: () {
              try {
                if (newsPassword.text == againNewsPassword.text &&
                    newsPassword.text.isNotEmpty &&
                    againNewsPassword.text.isNotEmpty &&
                    currientPassword.text.isNotEmpty) {
                  AuthService().changePassword(newsPassword.text);
                  currientPassword.clear();
                  newsPassword.clear();
                  againNewsPassword.clear();
                } else if (currientPassword.text.isEmpty &&
                    newsPassword.text.isEmpty &&
                    againNewsPassword.text.isEmpty) {
                  showToastError("Chưa nhập đủ thông tin !");
                } else {
                  showToastError("Mật khẩu mới không trùng nhau !");
                }
              } catch (e) {
                showToastError('Đổi mật khẩu thất bại do $e');
              }
            },
          ),
        ),
      ),
    );
  }
}
