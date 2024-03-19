import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  ButtonCustom({
    super.key,
    this.backgroundColor = Colors.white,
    this.textStyle,
    this.textButton = 'Đăng Nhập',
    required this.onTap,
    this.onloading = false,
  });
  Color backgroundColor;
  TextStyle? textStyle;
  String textButton;
  VoidCallback onTap;
  bool onloading;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          height: 65,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              width: 2,
              color: const Color(0xff0554F2),
            ),
          ),
          child: Center(
            child: onloading
                ? const Center(
                    child: Column(
                    children: [
                      SizedBox(height: 5),
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Loading...",
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ))
                : Text(
                    textButton,
                    style: textStyle,
                  ),
          ),
        ),
      ),
    );
  }
}
