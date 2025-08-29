import 'package:flutter/material.dart';
import 'package:invennico_fbp/core/config/app_colors.dart';

class AppThemeColors {
  static Color primaryColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? AppColors.colorWhite : AppColors.colorBlack;

  static Color negativePrimaryColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? AppColors.colorBlack : AppColors.colorWhite;
}