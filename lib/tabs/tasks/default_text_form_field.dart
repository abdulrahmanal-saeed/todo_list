import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../settings/settings_provider.dart';

class DefaultTextFormField extends StatelessWidget {
  const DefaultTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.maxLines = 1,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
  }) : assert(!obscureText || maxLines == 1,
            'Obscured fields cannot be multiline.');

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final int? maxLines;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);

    final textColor = settingsProvider.isDark ? Colors.black : Colors.black;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
        color: textColor,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: settingsProvider.isDark ? Colors.black : Colors.black,
        ),
        suffixIcon: suffixIcon,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: settingsProvider.isDark ? Colors.blueAccent : Colors.blue,
          ),
        ),
      ),
    );
  }
}
