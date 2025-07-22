import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:edu_mate/features/courses/data/repository/course_repository.dart';
import 'package:edu_mate/features/courses/data/models/courses_model.dart';

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
