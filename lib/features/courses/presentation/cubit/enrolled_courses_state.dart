import '../../data/models/enrolled_course_model.dart';

abstract class EnrolledCoursesState {
  const EnrolledCoursesState();
}

class EnrolledCoursesInitial extends EnrolledCoursesState {
  const EnrolledCoursesInitial();
}

class EnrolledCoursesLoading extends EnrolledCoursesState {
  const EnrolledCoursesLoading();
}

class EnrolledCoursesLoaded extends EnrolledCoursesState {
  final List<EnrolledCourse> enrolledCourses;

  const EnrolledCoursesLoaded(this.enrolledCourses);
}

class EnrolledCoursesError extends EnrolledCoursesState {
  final String message;

  const EnrolledCoursesError(this.message);
}
