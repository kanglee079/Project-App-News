import 'package:app_news/manage/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemsPersonal extends StatelessWidget {
  final IconData icon;
  final Color colorIcon;
  final String nameItem;
  final bool isSwitchItem;
  final bool isLanguage;
  final String textSecond;
  final Function()? ontap;
  const ItemsPersonal({
    super.key,
    required this.icon,
    this.colorIcon = Colors.black,
    required this.nameItem,
    this.isSwitchItem = false,
    this.isLanguage = false,
    this.textSecond = "Việt Nam (VN)",
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return InkWell(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: Row(
          children: [
            Icon(
              icon,
              size: 29,
              color: colorIcon,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                nameItem,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            if (isLanguage)
              Text(
                textSecond,
                style: Theme.of(context).textTheme.labelMedium,
              )
            else
              const Text(""),
            const SizedBox(width: 15),
            if (isSwitchItem)
              Row(
                children: [
                  Switch(
                    inactiveThumbColor: Theme.of(context).primaryColor,
                    inactiveTrackColor: Theme.of(context).indicatorColor,
                    activeColor: Colors.black,
                    activeTrackColor: Colors.white,
                    value: themeController.isDarkMode.value,
                    onChanged: (newValue) {
                      themeController.toggleTheme();
                    },
                  ),
                ],
              )
            else
              const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
