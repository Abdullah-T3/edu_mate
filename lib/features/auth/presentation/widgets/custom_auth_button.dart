import 'package:flutter/material.dart';

import '../../../../core/Responsive/models/DeviceInfo.dart';
import '../../../../core/theme/app_theme.dart';

Widget customAuthButton({
  required String text,
  required VoidCallback onPressed,
  required ThemeData theme,
  required AppColors colors,
  required TextTheme textTheme,
  required Deviceinfo deviceinfo,
  required bool isLoading,
}) {
  return Center(
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        minimumSize: Size(
          deviceinfo.screenWidth * 0.8,
          deviceinfo.screenHeight * 0.06,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.05),
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.primary, colors.accent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.03),
        ),
        child: Container(
          alignment: Alignment.center,
          width: deviceinfo.screenWidth * 0.8,
          height: deviceinfo.screenHeight * 0.06,
          child: isLoading
              ? CircularProgressIndicator()
              : Text(
                  text,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: deviceinfo.screenWidth * 0.05,
                    color: colors.scaffoldBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    ),
  );
}
