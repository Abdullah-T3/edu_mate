import 'dart:developer';

import 'package:edu_mate/features/courses/data/models/enrolled_course_model.dart';
import 'package:edu_mate/features/courses/data/repository/course_repository.dart';
import 'package:injectable/injectable.dart';

import '../datasource/courses_remote_datasource.dart';
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
        // Handle the response data which is already a List<dynamic>
        if (response.data is List<dynamic>) {
          return (response.data as List<dynamic>)
              .map((json) => Course.fromJson(json))
              .toList();
        } else {
          throw Exception('Invalid response format: expected List<dynamic>');
        }
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e, trace) {
      log('Error fetching courses: $e');
      log('Stack trace: $trace');
      throw Exception('Failed to load courses: $e');
    }
  }

  @override
  Future<List<EnrolledCourse>> fetchEnrolledCourses() async {
    try {
      final response = await _coursesRemoteDatasource.fetchEntolledCourses();
      log('Response status: ${response.statusCode}');
      log('Response data type: ${response.data.runtimeType}');
      log('Response data: ${response.data}');

      if (response.statusCode == 200) {
        // Handle the response data which is already a List<dynamic>
        if (response.data is List<dynamic>) {
          return enrolledCourseFromJson(response.data as List<dynamic>);
        } else {
          throw Exception('Invalid response format: expected List<dynamic>');
        }
      } else {
        throw Exception(
          'Failed to load enrolled courses: ${response.statusCode}',
        );
      }
    } catch (e, trace) {
      log('Error fetching enrolled courses: $e');
      log('Stack trace: $trace');
      throw Exception('Failed to load enrolled courses: $e');
    }
  }
}
