import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invennico_fbp/core/utils/theme/app_theme_color.dart';

class FormWidgets {
  static Widget validatedTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    bool isLabel = true,
  }) {
    final Color primary = AppThemeColors.primaryColor(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: isLabel ? label : null,
        hintText: !isLabel ? label : null,
        labelStyle: TextStyle(color: primary),
        hintStyle: TextStyle(color: primary.withOpacity(0.6)),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  static Widget validatedDropdown<T>({
    required BuildContext context,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required String label,
    required String? Function(T?) validator,
    required void Function(T?) onChanged,
    bool isLabel = true,
  }) {
    final Color primary = AppThemeColors.primaryColor(context);

    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      decoration: InputDecoration(
        labelText: isLabel ? label : null,
        hintText: !isLabel ? label : null,
        labelStyle: TextStyle(color: primary),
        hintStyle: TextStyle(color: primary.withOpacity(0.6)),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
