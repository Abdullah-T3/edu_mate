import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/Responsive/models/DeviceInfo.dart';
import '../../../../core/theme/app_theme.dart';

class AuthButtonSkeleton extends StatelessWidget {
  final Deviceinfo deviceinfo;

  const AuthButtonSkeleton({super.key, required this.deviceinfo});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Skeletonizer(
      enabled: true,
      child: Center(
        child: Container(
          width: deviceinfo.screenWidth * 0.8,
          height: deviceinfo.screenHeight * 0.06,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colors.primary, colors.accent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.05),
          ),
          child: Center(
            child: Container(
              height: 20,
              width: deviceinfo.screenWidth * 0.3,
              decoration: BoxDecoration(
                color: colors.scaffoldBackground,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
