import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/enrolled_course_model.dart';
import '../../data/repository/course_repository.dart';
import 'enrolled_courses_state.dart';

@injectable
class EnrolledCoursesCubit extends Cubit<EnrolledCoursesState> {
  final CourseRepository _courseRepository;

  EnrolledCoursesCubit(this._courseRepository)
    : super(const EnrolledCoursesInitial());

  Future<void> fetchEnrolledCourses() async {
    emit(const EnrolledCoursesLoading());

    try {
      final enrolledCourses = await _courseRepository.fetchEnrolledCourses();
      emit(EnrolledCoursesLoaded(enrolledCourses));
    } catch (e) {
      emit(EnrolledCoursesError(e.toString()));
    }
  }

  void toggleFavorite(int courseId) {
    final currentState = state;
    if (currentState is EnrolledCoursesLoaded) {
      final updatedCourses = currentState.enrolledCourses.map((course) {
        if (course.course.id == courseId) {
          return course.copyWith(isFavorite: !course.isFavorite);
        }
        return course;
      }).toList();

      emit(EnrolledCoursesLoaded(updatedCourses));
    }
  }

  List<EnrolledCourse> getFilteredCourses(String filter) {
    final currentState = state;
    if (currentState is EnrolledCoursesLoaded) {
      switch (filter.toLowerCase()) {
        case 'all courses':
          return currentState.enrolledCourses;
        case 'in progress':
          return currentState.enrolledCourses
              .where((course) => course.progress > 0 && course.progress < 100)
              .toList();
        case 'completed':
          return currentState.enrolledCourses
              .where((course) => course.progress == 100)
              .toList();
        default:
          return currentState.enrolledCourses;
      }
    }
    return [];
  }
}
