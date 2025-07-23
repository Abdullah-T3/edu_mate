import 'package:edu_mate/core/Responsive/UiComponents/InfoWidget.dart';
import 'package:edu_mate/core/Responsive/models/DeviceInfo.dart';
import 'package:edu_mate/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/routs.dart';
import '../../data/models/courses_model.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback? onTap;

  const CourseCard({super.key, required this.course, this.onTap});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return RepaintBoundary(
      child: GestureDetector(
        onTap: () {
          context.push(Routes.courseDetailsScreen, extra: {'course': course});
        },
        child: InfoWidget(
          builder: (context, deviceinfo) => Container(
            margin: EdgeInsets.only(bottom: deviceinfo.screenHeight * 0.02),
            decoration: BoxDecoration(
              color: appColors.cardBackground,
              borderRadius: BorderRadius.circular(
                deviceinfo.screenWidth * 0.02,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: deviceinfo.screenWidth * 0.02,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Header with Fallback
                _buildImageHeader(deviceinfo),
                // Course Details
                _buildCourseDetails(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageHeader(Deviceinfo deviceinfo) {
    return Container(
      height: deviceinfo.screenWidth * 0.7 * 0.4,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: Stack(
          children: [
            // Image with fallback to gradient
            course.image.isNotEmpty
                ? Image.network(
                    course.image,
                    width: deviceinfo.screenWidth * 0.7,
                    height: deviceinfo.screenWidth * 0.7 * 0.4,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildGradientHeader();
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildGradientHeader();
                    },
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded) return child;
                          return AnimatedOpacity(
                            opacity: frame == null ? 0 : 1,
                            duration: const Duration(milliseconds: 300),
                            child: child,
                          );
                        },
                  )
                : _buildGradientHeader(),
            // Category badge - show for both image and gradient
            Positioned(
              top: deviceinfo.screenHeight * 0.01,
              right: deviceinfo.screenWidth * 0.02,
              child: Builder(
                builder: (context) {
                  final appColors = Theme.of(context).extension<AppColors>()!;

                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: deviceinfo.screenWidth * 0.02,
                      vertical: deviceinfo.screenHeight * 0.005,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(
                        deviceinfo.screenWidth * 0.02,
                      ),
                    ),
                    child: Text(
                      course.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Play button overlay
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xE6FFFFFF), // Using const color
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: _getGradientColors(course.category).first,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientHeader() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        gradient: _getCourseGradient(course.category),
      ),
      child: Center(
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Color(0xE6FFFFFF), // Using const color
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.play_arrow,
            color: _getGradientColors(course.category).first,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget _buildCourseDetails() {
    return Builder(
      builder: (context) {
        final appColors = Theme.of(context).extension<AppColors>()!;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: appColors.primaryText,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    size: 16,
                    color: appColors.secondaryText,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Free',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.star, size: 16, color: Color(0xFFFFD700)),
                  const SizedBox(width: 4),
                  Text(
                    course.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: appColors.primaryText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  LinearGradient _getCourseGradient(String category) {
    final colors = _getGradientColors(category);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }

  // Memoized gradient colors for better performance
  static final Map<String, List<Color>> _gradientCache = {};

  List<Color> _getGradientColors(String category) {
    final key = category.toLowerCase();
    if (_gradientCache.containsKey(key)) {
      return _gradientCache[key]!;
    }

    List<Color> colors;
    switch (key) {
      case 'programming':
        colors = const [Color(0xFF8B5CF6), Color(0xFF1E40AF)];
        break;
      case 'design':
        colors = const [Color(0xFFEC4899), Color(0xFF8B5CF6)];
        break;
      case 'data science':
        colors = const [Color(0xFF3B82F6), Color(0xFF0D9488)];
        break;
      default:
        colors = const [Color(0xFF6366F1), Color(0xFF1E40AF)];
        break;
    }

    _gradientCache[key] = colors;
    return colors;
  }
}
