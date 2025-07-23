import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/courses_model.dart';

part 'search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  void searchCourses(String query, List<Course> allCourses) {
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }

    try {
      emit(SearchLoading());

      final filteredCourses = allCourses.where((course) {
        final searchQuery = query.toLowerCase().trim();
        return course.title.toLowerCase().contains(searchQuery) ||
            course.description.toLowerCase().contains(searchQuery) ||
            course.category.toLowerCase().contains(searchQuery);
      }).toList();

      if (filteredCourses.isEmpty) {
        emit(SearchNoResults(query));
      } else {
        emit(SearchResults(filteredCourses, query));
      }
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void clearSearch() {
    emit(SearchInitial());
  }

  void setSearching(bool isSearching) {
    if (isSearching && state is SearchInitial) {
      emit(SearchActive());
    } else if (!isSearching &&
        (state is SearchActive ||
            state is SearchLoading ||
            state is SearchResults ||
            state is SearchNoResults)) {
      emit(SearchInitial());
    }
  }
}
