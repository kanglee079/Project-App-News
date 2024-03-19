import 'package:flutter/material.dart';

class ButtonCustomSocial extends StatelessWidget {
  ButtonCustomSocial({
    super.key,
    this.backgroundColor = Colors.white,
    this.textStyle,
    this.textButton = 'Đăng Nhập',
    this.urlSocial = "assets/image/backgroudImage/google.png",
    required this.onTap,
  });
  Color backgroundColor;
  TextStyle? textStyle;
  String textButton;
  VoidCallback onTap;
  String urlSocial;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              width: 2,
              color: const Color(0xff0554F2),
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 25,
                  height: 25,
                  child: Image.asset(
                    urlSocial,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  textButton,
                  style: textStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
