import 'package:edu_mate/core/Responsive/UiComponents/InfoWidget.dart';
import 'package:edu_mate/core/Responsive/models/DeviceInfo.dart';
import 'package:edu_mate/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../../data/models/courses_model.dart';
import '../../data/models/enrolled_course_model.dart';

class MyCourseCard extends StatelessWidget {
  final EnrolledCourse enrolledCourse;
  final Function(int) onFavoriteToggle;
  final Deviceinfo deviceInfo;

  const MyCourseCard({
    super.key,
    required this.enrolledCourse,
    required this.onFavoriteToggle,
    required this.deviceInfo,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    final course = enrolledCourse.course;

    return InfoWidget(
      builder: (context, deviceinfo) => Container(
        margin: EdgeInsets.only(bottom: deviceinfo.screenHeight * 0.02),
        padding: EdgeInsets.all(deviceinfo.screenWidth * 0.03),
        decoration: BoxDecoration(
          color: appColors.cardBackground,
          borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.02),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: deviceinfo.screenWidth * 0.02,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildCourseThumbnail(course, appColors, deviceinfo),
            SizedBox(width: deviceinfo.screenWidth * 0.03),
            Expanded(child: _buildCourseDetails(course, appColors, deviceinfo)),
            _buildFavoriteButton(appColors, deviceinfo),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseThumbnail(
    Course course,
    AppColors appColors,
    Deviceinfo deviceinfo,
  ) {
    return Container(
      width: deviceinfo.screenWidth * 0.15,
      height: deviceinfo.screenWidth * 0.15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.02),
        color: appColors.inputBackground,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.02),
        child: course.image.isNotEmpty
            ? Image.network(
                course.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderThumbnail(appColors, deviceinfo);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildPlaceholderThumbnail(appColors, deviceinfo);
                },
              )
            : _buildPlaceholderThumbnail(appColors, deviceinfo),
      ),
    );
  }

  Widget _buildPlaceholderThumbnail(
    AppColors appColors,
    Deviceinfo deviceinfo,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [appColors.inputBackground, appColors.divider],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        Icons.play_circle_outline,
        color: appColors.tertiaryText,
        size: deviceinfo.screenWidth * 0.1,
      ),
    );
  }

  Widget _buildCourseDetails(
    Course course,
    AppColors appColors,
    Deviceinfo deviceinfo,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          course.title,
          style: TextStyle(
            fontSize: deviceinfo.screenWidth * 0.036,
            fontWeight: FontWeight.bold,
            color: appColors.primaryText,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: deviceinfo.screenHeight * 0.01),
        Text(
          '${course.instructor.name} • ${course.duration}',
          style: TextStyle(fontSize: 14, color: appColors.tertiaryText),
        ),
        SizedBox(height: deviceinfo.screenHeight * 0.01),
        Row(
          children: [
            Expanded(child: _buildProgressBar(appColors, deviceinfo)),
            SizedBox(width: deviceinfo.screenWidth * 0.02),
            Text(
              '${enrolledCourse.progress}%',
              style: TextStyle(
                fontSize: deviceinfo.screenWidth * 0.032,
                fontWeight: FontWeight.w600,
                color: enrolledCourse.progress == 100
                    ? const Color(0xFF10B981)
                    : appColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressBar(AppColors appColors, Deviceinfo deviceinfo) {
    final progress = enrolledCourse.progress / 100.0;
    final isCompleted = enrolledCourse.progress == 100;

    return Container(
      height: deviceinfo.screenHeight * 0.02,
      decoration: BoxDecoration(
        color: appColors.divider,
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFF10B981) : appColors.primary,
            borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.02),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(AppColors appColors, Deviceinfo deviceinfo) {
    return GestureDetector(
      onTap: () => onFavoriteToggle(enrolledCourse.course.id),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          enrolledCourse.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: enrolledCourse.isFavorite
              ? const Color(0xFFEF4444)
              : appColors.tertiaryText,
          size: deviceinfo.screenWidth * 0.06,
        ),
      ),
    );
  }
}
