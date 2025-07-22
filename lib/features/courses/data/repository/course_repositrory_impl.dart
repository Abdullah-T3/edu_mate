import 'dart:developer';

import 'package:edu_mate/features/courses/data/datasource/courses_remote_datasource.dart';
import 'package:edu_mate/features/courses/data/repository/course_repository.dart';
import 'package:injectable/injectable.dart';

import '../models/courses_model.dart';

@injectable
class CourseRepositroryImpl implements CourseRepository {
  final CoursesRemoteDatasource _coursesRemoteDatasource;
  CourseRepositroryImpl(this._coursesRemoteDatasource);

  @override
  Future<List<Course>> fetchCourses() async {
    try {
      final response = await _coursesRemoteDatasource.fetchCourses();
      log('Response status: ${response.statusCode}');
      log('Response data type: ${response.data.runtimeType}');
      log('Response data: ${response.data}');

      if (response.statusCode == 200) {
        // Handle different response data structures
        if (response.data is List) {
          // Direct array of courses
          return List<Course>.from(
            response.data.map((x) => Course.fromJson(x)),
          );
        } else if (response.data is Map<String, dynamic>) {
          // Check if data is nested in a 'data' field
          final data = response.data as Map<String, dynamic>;
          if (data.containsKey('data') && data['data'] is List) {
            return List<Course>.from(
              (data['data'] as List).map((x) => Course.fromJson(x)),
            );
          } else if (data.containsKey('courses') && data['courses'] is List) {
            return List<Course>.from(
              (data['courses'] as List).map((x) => Course.fromJson(x)),
            );
          } else {
            throw Exception('Unexpected response structure: ${data.keys}');
          }
        } else if (response.data is String) {
          // JSON string that needs to be parsed
          return courseFromJson(response.data);
        } else {
          throw Exception(
            'Unexpected response data format: ${response.data.runtimeType}',
          );
        }
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e, trace) {
      log('Error fetching courses: $e');
      log('Stack trace: $trace');

      // Return mock data for testing while API is being fixed
      log('Returning mock data for testing');
      throw Exception('Failed to load courses, returning mock data: $e');
    }
  }
}
