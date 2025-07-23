import 'package:bloc/bloc.dart';
import 'package:edu_mate/features/courses/data/models/courses_model.dart'
    show Course;
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';

import '../../data/repository/course_repository.dart';

part 'courses_state.dart';

@injectable
class CoursesCubit extends Cubit<CoursesState> {
  final CourseRepository _courseRepository;

  CoursesCubit(this._courseRepository) : super(CoursesInitial());

  Future<void> fetchCourses() async {
    try {
      emit(CoursesLoading());
      final courses = await _courseRepository.fetchCourses();
      emit(CoursesLoaded(courses));
    } catch (e) {
      emit(CoursesError(e.toString()));
    }
  }
}
