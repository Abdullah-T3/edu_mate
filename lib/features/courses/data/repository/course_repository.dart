import '../models/courses_model.dart';

abstract class CourseRepository {
  Future<List<Course>> fetchCourses();
}
