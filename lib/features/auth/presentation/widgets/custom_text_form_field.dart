import 'package:edu_mate/core/Responsive/models/DeviceInfo.dart';
import 'package:edu_mate/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AuthTextFormField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Deviceinfo deviceinfo;

  const AuthTextFormField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    required this.deviceinfo,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.bodyMedium),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: hintText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            contentPadding: EdgeInsets.symmetric(
              horizontal: deviceinfo.screenWidth * 0.02,
              vertical: deviceinfo.screenHeight * 0.015,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                deviceinfo.screenWidth * 0.02,
              ),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                deviceinfo.screenWidth * 0.02,
              ),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                deviceinfo.screenWidth * 0.02,
              ),
              borderSide: BorderSide(
                color: Theme.of(
                  context,
                ).extension<AppColors>()!.primary.withOpacity(0.8),
                width: 2.0,
              ),
            ),
          ),
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
