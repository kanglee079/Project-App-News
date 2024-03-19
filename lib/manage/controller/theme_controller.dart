import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  ThemeData get themeData => isDarkMode.value
      ? ThemeData.dark().copyWith(
          primaryColor: Colors.blueGrey[800],
          scaffoldBackgroundColor: Colors.grey[850],
          cardColor: Colors.grey[800],
          hintColor: Colors.blueGrey[200],
          indicatorColor: Colors.white,
          textTheme: TextTheme(
            labelLarge: TextStyle(
              color: Colors.grey[300],
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
            labelMedium: TextStyle(
              color: Colors.grey[300],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            labelSmall: TextStyle(
              color: Colors.blueGrey[200],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            titleLarge: TextStyle(
              color: Colors.blueGrey[200],
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
            titleMedium: TextStyle(
              color: Colors.grey[300],
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            titleSmall: TextStyle(
              color: Colors.grey[300],
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            bodyMedium: TextStyle(
              color: Colors.grey[300],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            bodySmall: TextStyle(
              color: Colors.grey[300],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            headlineSmall: TextStyle(
              color: Colors.blueGrey[200],
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            headlineMedium: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            headlineLarge: TextStyle(
              color: Colors.grey[300],
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.blueGrey[800],
            secondary: Colors.amber[300],
            surface: Colors.grey[700],
            background: Colors.grey[850],
            error: Colors.red[700],
            onPrimary: Colors.grey[300],
            onSecondary: Colors.black,
            onSurface: Colors.white,
            onBackground: Colors.grey[300],
            onError: Colors.white,
            brightness: Brightness.dark,
          ),
          appBarTheme: AppBarTheme(
            color: Colors.grey[900],
            iconTheme: IconThemeData(color: Colors.grey[300]),
          ),
          iconTheme: IconThemeData(
            color: Colors.grey[300],
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Colors.amber,
            textTheme: ButtonTextTheme.primary,
          ),
        )
      : ThemeData.light().copyWith(
          primaryColor: const Color(0xff0554F2),
          cardColor: Colors.white,
          hintColor: Colors.blueAccent,
          indicatorColor: Colors.grey.shade300,
          textTheme: const TextTheme(
            labelLarge: TextStyle(
              color: Color(0xff343434),
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
            labelMedium: TextStyle(
              color: Color(0xff343434),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            labelSmall: TextStyle(
              color: Color(0xff0554F2),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            titleLarge: TextStyle(
              color: Color(0xff0554F2),
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
            titleMedium: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            titleSmall: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            bodyMedium: TextStyle(
              color: Color(0xff343434),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            bodySmall: TextStyle(
              color: Color(0xff343434),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            headlineSmall: TextStyle(
              color: Color(0xff0554F2),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            headlineMedium: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            headlineLarge: TextStyle(
              color: Color(0xff343434),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            displaySmall: TextStyle(
              color: Colors.black38,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            displayMedium: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: const Color(0xff0554F2),
          ),
        );

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}
