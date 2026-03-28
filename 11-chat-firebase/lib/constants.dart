import 'package:flutter/material.dart';

class AppRoutes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String chat = '/chat';
}

class AppColors {
  static const Color primary = Color(0xFF2979FF);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color accent = Color(0xFF448AFF);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color myMessageColor = Color(0xFF2979FF);
  static const Color otherMessageColor = Color(0xFFE0E0E0);
  static const Color white = Colors.white;
  static const Color textDark = Color(0xFF212121);
  static const Color textLight = Color(0xFF757575);
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const TextStyle messageText = TextStyle(
    fontSize: 15.0,
    height: 1.4,
  );

  static const TextStyle senderText = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
  );

  static const TextStyle inputText = TextStyle(
    fontSize: 16.0,
    color: AppColors.textDark,
  );
}

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Введите сообщение...',
  hintStyle: TextStyle(color: AppColors.textLight),
  border: InputBorder.none,
);

const kTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
    borderSide: BorderSide(color: AppColors.primary),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
    borderSide: BorderSide(color: AppColors.textLight, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12.0)),
    borderSide: BorderSide(color: AppColors.primary, width: 2.0),
  ),
);
