import 'package:flutter/material.dart';
import 'package:invennico_fbp/core/config/app_assets.dart';


class AppThemeAssets {
  static String themedBackground(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? '${AppAssets.assetImages}/dark_bg.jpg'
        : '${AppAssets.assetImages}/light_bg.jpg';
  }
}