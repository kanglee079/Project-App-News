import 'package:flutter/material.dart';

import 'text_form_field.dart';

class FormLoginWidget extends StatelessWidget {
  const FormLoginWidget({
    super.key,
    required GlobalKey<FormState> keyLoginForm,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  })  : _keyLoginForm = keyLoginForm,
        _emailController = emailController,
        _passwordController = passwordController;

  final GlobalKey<FormState> _keyLoginForm;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyLoginForm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email hoặc Tên Đăng Nhập",
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
        ],
      ),
    );
  }
}
