part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {
  final SearchActive initialState = SearchActive();
}

final class SearchActive extends SearchState {}

final class SearchLoading extends SearchState {}

final class SearchResults extends SearchState {
  final List<Course> courses;
  final String query;
  SearchResults(this.courses, this.query);
}

final class SearchNoResults extends SearchState {
  final String query;
  SearchNoResults(this.query);
}

final class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
