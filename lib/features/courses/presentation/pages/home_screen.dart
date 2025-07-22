import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/courses_cubit.dart';
import '../cubit/search_cubit.dart';
import '../../data/models/courses_model.dart';
import '../widgets/course_header.dart';
import '../widgets/course_list.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/error_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  int _selectedIndex = 0;

  // Search functionality
  final TextEditingController _searchController = TextEditingController();
  List<Course> _allCourses = [];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeController.forward();
    _slideController.forward();

    // Fetch courses when the screen loads
    context.read<CoursesCubit>().fetchCourses();

    // Listen to search changes
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    context.read<SearchCubit>().searchCourses(query, _allCourses);
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<SearchCubit>().clearSearch();
  }

  void _toggleSearch() {
    context.read<SearchCubit>().setSearching(true);
  }

  void _onNavigationItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, searchState) {
                return CourseHeader(
                  isSearching:
                      searchState is SearchActive ||
                      searchState is SearchLoading ||
                      searchState is SearchResults ||
                      searchState is SearchNoResults,
                  searchController: _searchController,
                  onSearchToggle: _toggleSearch,
                  onClearSearch: _clearSearch,
                );
              },
            ),
            Expanded(
              child: BlocBuilder<CoursesCubit, CoursesState>(
                builder: (context, coursesState) {
                  if (coursesState is CoursesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF6366F1),
                      ),
                    );
                  } else if (coursesState is CoursesLoaded) {
                    // Update all courses
                    _allCourses = coursesState.courses;

                    return BlocBuilder<SearchCubit, SearchState>(
                      builder: (context, searchState) {
                        if (searchState is SearchInitial) {
                          // Show all courses
                          return CourseList(
                            courses: _allCourses,
                            isSearching: false,
                            onRefresh: () {
                              context.read<CoursesCubit>().fetchCourses();
                            },
                          );
                        } else if (searchState is SearchLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF6366F1),
                            ),
                          );
                        } else if (searchState is SearchResults) {
                          return CourseList(
                            courses: searchState.courses,
                            isSearching: true,
                            onRefresh: () {
                              context.read<CoursesCubit>().fetchCourses();
                            },
                          );
                        } else if (searchState is SearchNoResults) {
                          return CourseList(
                            courses: [],
                            isSearching: true,
                            onRefresh: () {
                              context.read<CoursesCubit>().fetchCourses();
                            },
                          );
                        } else {
                          return CourseList(
                            courses: _allCourses,
                            isSearching: false,
                            onRefresh: () {
                              context.read<CoursesCubit>().fetchCourses();
                            },
                          );
                        }
                      },
                    );
                  } else if (coursesState is CoursesError) {
                    return CourseErrorWidget(
                      message: coursesState.message,
                      onRetry: () {
                        context.read<CoursesCubit>().fetchCourses();
                      },
                    );
                  } else {
                    return const Center(child: Text('No courses available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemSelected: _onNavigationItemSelected,
      ),
    );
  }
}
