import '../models/courses_model.dart';
import '../models/enrolled_course_model.dart';

abstract class CourseRepository {
  Future<List<Course>> fetchCourses();
  Future<List<EnrolledCourse>> fetchEnrolledCourses();
}
