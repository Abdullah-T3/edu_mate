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

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Course Thumbnail
          _buildCourseThumbnail(course),
          const SizedBox(width: 12),
          // Course Details
          Expanded(child: _buildCourseDetails(course, appColors)),
          // Favorite Button
          _buildFavoriteButton(appColors),
        ],
      ),
    );
  }

  Widget _buildCourseThumbnail(Course course) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFF3F4F6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: course.image.isNotEmpty
            ? Image.network(
                course.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderThumbnail();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildPlaceholderThumbnail();
                },
              )
            : _buildPlaceholderThumbnail(),
      ),
    );
  }

  Widget _buildPlaceholderThumbnail() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xFFE5E7EB), Color(0xFFD1D5DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Icon(
        Icons.play_circle_outline,
        color: Color(0xFF9CA3AF),
        size: 24,
      ),
    );
  }

  Widget _buildCourseDetails(Course course, AppColors appColors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Course Title
        Text(
          course.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        // Instructor and Duration
        Text(
          '${course.instructor.name} • ${course.duration}',
          style: TextStyle(fontSize: 14, color: appColors.tertiaryText),
        ),
        const SizedBox(height: 12),
        // Progress Bar and Percentage
        Row(
          children: [
            Expanded(child: _buildProgressBar()),
            const SizedBox(width: 8),
            Text(
              '${enrolledCourse.progress}%',
              style: TextStyle(
                fontSize: 12,
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

  Widget _buildProgressBar() {
    final progress = enrolledCourse.progress / 100.0;
    final isCompleted = enrolledCourse.progress == 100;

    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: isCompleted
                ? const Color(0xFF10B981)
                : const Color(0xFF6A85F1),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(AppColors appColors) {
    return GestureDetector(
      onTap: () => onFavoriteToggle(enrolledCourse.course.id),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          enrolledCourse.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: enrolledCourse.isFavorite
              ? const Color(0xFFEF4444)
              : appColors.tertiaryText,
          size: 20,
        ),
      ),
    );
  }
}
