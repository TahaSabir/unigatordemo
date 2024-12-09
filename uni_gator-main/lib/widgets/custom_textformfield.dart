import 'package:flutter/material.dart';

import '/utils/app_colors.dart';
import '/widgets/app_text_style.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool enabled; // Add enabled property

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.controller,
    this.onSaved,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text, // Default to text input type
    this.enabled = true, // Default to enabled
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText:
          obscureText, // Added obscureText property for password fields
      validator: validator,
      onSaved: onSaved,
      keyboardType: keyboardType,
      enabled: enabled,
      style: AppTextTheme.getLightTextTheme(context)
          .bodyMedium, // Custom text style
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextTheme.getLightTextTheme(context)
            .bodySmall, // Hint text style
        // filled: true,
        // fillColor: Colors.grey[200], // Fill color
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 24.0, vertical: 10.0), // Padding around text
        border: const OutlineInputBorder(
          borderSide: BorderSide.none, // No border
          borderRadius:
              BorderRadius.all(Radius.circular(50)), // Circular border
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: AppColors.primary), // Blue border when focused
          borderRadius:
              BorderRadius.all(Radius.circular(50)), // Circular border
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: AppColors.primary), // Blue border when focused
          borderRadius:
              BorderRadius.all(Radius.circular(50)), // Circular border
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red), // Red border for error
          borderRadius:
              BorderRadius.all(Radius.circular(50)), // Circular border
        ),

        disabledBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: AppColors.primary), // Blue border when focused
          borderRadius:
              BorderRadius.all(Radius.circular(50)), // Circular border
        ),
        // Circular border
      ),
    );
  }
}
