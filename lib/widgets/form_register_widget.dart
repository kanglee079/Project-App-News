import 'package:flutter/material.dart';

import 'text_form_field.dart';

class FormRegisterWidget extends StatelessWidget {
  const FormRegisterWidget({
    super.key,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    required TextEditingController displayNameController,
    required GlobalKey<FormState> keyRegisterForm,
  })  : _keyRegisterForm = keyRegisterForm,
        _emailController = emailController,
        _passwordController = passwordController,
        _confirmPasswordController = confirmPasswordController,
        _displayNameController = displayNameController;

  final GlobalKey<FormState> _keyRegisterForm;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final TextEditingController _confirmPasswordController;
  final TextEditingController _displayNameController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyRegisterForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tên Hiển Thị",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 5),
          TextFormCustom(
            controller: _displayNameController,
            hintText: 'Tên hiển thị của bạn',
          ),
          const SizedBox(height: 15),
          Text(
            "Email hoặc Tên Đăng Kí",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 5),
          TextFormCustom(
            controller: _emailController,
            errorCheck: 'email',
          ),
          const SizedBox(height: 15),
          Text(
            "Mật Khẩu",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 5),
          TextFormCustom(
            controller: _passwordController,
            hintText: 'Mật khẩu của bạn',
            iconPrefix: Icons.lock,
            isPassword: true,
          ),
          const SizedBox(height: 15),
          Text(
            "Nhập Lại Mật Khẩu",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 5),
          TextFormCustom(
            controller: _confirmPasswordController,
            hintText: 'Mật khẩu của bạn',
            iconPrefix: Icons.lock,
            isPassword: true,
          ),
        ],
      ),
    );
  }
}
