import 'package:edu_mate/features/courses/data/models/courses_model.dart';

abstract class CourseRepository {
  Future<List<Course>> fetchCourses();
}
