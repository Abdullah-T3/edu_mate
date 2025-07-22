part of 'courses_cubit.dart';

@immutable
sealed class CoursesState {}

final class CoursesInitial extends CoursesState {}

final class CoursesLoading extends CoursesState {}

final class CoursesLoaded extends CoursesState {
  final List<Course> courses;
  CoursesLoaded(this.courses);
}

final class CoursesError extends CoursesState {
  final String message;
  CoursesError(this.message);
}
