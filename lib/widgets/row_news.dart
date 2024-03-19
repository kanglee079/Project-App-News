import 'package:flutter/material.dart';

class RowNews extends StatelessWidget {
  String title;
  Function()? ontap;

  RowNews({super.key, required this.title, this.ontap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        InkWell(
          onTap: ontap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Text(
                  "Xem tất cả",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 16),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 19,
                  color: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
