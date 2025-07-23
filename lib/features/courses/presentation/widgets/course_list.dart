import 'package:edu_mate/core/Responsive/models/DeviceInfo.dart';
import 'package:flutter/material.dart';
import '../../data/models/courses_model.dart';
import 'course_card.dart';

class CourseList extends StatefulWidget {
  final List<Course> courses;
  final bool isSearching;
  final VoidCallback onRefresh;
  final Deviceinfo deviceInfo;

  const CourseList({
    super.key,
    required this.courses,
    required this.isSearching,
    required this.onRefresh,
    required this.deviceInfo,
  });

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => widget.onRefresh(),
      child: widget.courses.isEmpty && widget.isSearching
          ? _buildNoResultsWidget()
          : ListView.builder(
              padding: EdgeInsets.fromLTRB(
                widget.deviceInfo.screenWidth * 0.05,
                widget.deviceInfo.screenHeight * 0.02,
                widget.deviceInfo.screenWidth * 0.05,
                16,
              ),
              itemCount:
                  widget.courses.length + 2, // +2 for section title and spacing
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildSectionTitle();
                } else if (index == 1) {
                  return SizedBox(
                    height: widget.deviceInfo.screenHeight * 0.02,
                  );
                } else {
                  final currnetIndex =
                      index - 2; // Adjust for section title and spacing
                  final course = widget.courses[currnetIndex];
                  return CourseCard(course: course);
                }
              },
            ),
    );
  }

  Widget _buildSectionTitle() {
    return Text(
      widget.isSearching ? 'Search Results' : 'Featured Courses',
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF374151),
      ),
    );
  }

  Widget _buildNoResultsWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Color(0xFF9CA3AF)),
          SizedBox(height: 16),
          Text(
            'No courses found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your search terms',
            style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }
}
