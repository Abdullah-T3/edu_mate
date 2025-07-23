import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/Responsive/models/DeviceInfo.dart';
import '../../../../core/theme/app_theme.dart';

class CourseSkeleton extends StatelessWidget {
  final Deviceinfo deviceInfo;

  const CourseSkeleton({super.key, required this.deviceInfo});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(
          deviceInfo.screenWidth * 0.05,
          deviceInfo.screenHeight * 0.02,
          deviceInfo.screenWidth * 0.05,
          16,
        ),
        itemCount: 6, // Show 6 skeleton items
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: deviceInfo.screenHeight * 0.02),
            decoration: BoxDecoration(
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course image skeleton
                Container(
                  height: deviceInfo.screenHeight * 0.15,
                  decoration: BoxDecoration(
                    color: colors.inputBackground,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(deviceInfo.screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course title skeleton
                      Container(
                        height: 20,
                        width: deviceInfo.screenWidth * 0.6,
                        decoration: BoxDecoration(
                          color: colors.inputBackground,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: deviceInfo.screenHeight * 0.01),
                      // Course description skeleton
                      Container(
                        height: 16,
                        width: deviceInfo.screenWidth * 0.8,
                        decoration: BoxDecoration(
                          color: colors.inputBackground,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: deviceInfo.screenHeight * 0.01),
                      Container(
                        height: 16,
                        width: deviceInfo.screenWidth * 0.5,
                        decoration: BoxDecoration(
                          color: colors.inputBackground,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: deviceInfo.screenHeight * 0.02),
                      // Course details skeleton
                      Row(
                        children: [
                          Container(
                            height: 16,
                            width: deviceInfo.screenWidth * 0.2,
                            decoration: BoxDecoration(
                              color: colors.inputBackground,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(width: deviceInfo.screenWidth * 0.04),
                          Container(
                            height: 16,
                            width: deviceInfo.screenWidth * 0.15,
                            decoration: BoxDecoration(
                              color: colors.inputBackground,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
