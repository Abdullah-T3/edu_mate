import 'dart:async';
import 'package:edu_mate/core/Responsive/UiComponents/InfoWidget.dart';
import 'package:edu_mate/core/Responsive/models/DeviceInfo.dart';
import 'package:edu_mate/core/theme/app_theme.dart';
import 'package:edu_mate/features/courses/presentation/pages/my_courses_standalone_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edu_mate/features/auth/presentation/pages/profile_screen.dart';

import '../../data/models/courses_model.dart';
import '../cubit/courses_cubit.dart';
import '../cubit/search_cubit.dart';
import '../widgets/course_header.dart';
import '../widgets/course_list.dart';
import '../widgets/course_skeleton.dart';
import '../widgets/error_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Search functionality
  final TextEditingController _searchController = TextEditingController();
  List<Course> _allCourses = [];

  // Performance optimization: Memoize navigation items
  late final List<BottomNavigationBarItem> _navigationItems;

  // Debounced search to improve performance
  Timer? _searchDebounceTimer;

  @override
  void initState() {
    super.initState();
    // Listen to search changes with debouncing
    _searchController.addListener(_onSearchChanged);

    // Initialize navigation items once
    _navigationItems = _buildNavigationItems();
  }

  List<BottomNavigationBarItem> _buildNavigationItems() {
    return const [
      BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
      BottomNavigationBarItem(
        icon: Icon(Icons.book_rounded),
        label: 'My Courses',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_rounded),
        label: 'Profile',
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      final query = _searchController.text;
      context.read<SearchCubit>().searchCourses(query, _allCourses);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<SearchCubit>().clearSearch();
  }

  void _toggleSearch() {
    final searchCubit = context.read<SearchCubit>();
    if (searchCubit.state is SearchInitial) {
      searchCubit.setSearching(true);
    }
  }

  void _onNavigationItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildAppBar(Deviceinfo deviceinfo, AppColors appColors) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: deviceinfo.screenWidth * 0.05),
      padding: EdgeInsets.symmetric(
        horizontal: deviceinfo.screenWidth * 0.04,
        vertical: deviceinfo.screenHeight * 0.015,
      ),
      decoration: BoxDecoration(
        color: appColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontSize: deviceinfo.screenWidth * 0.05,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Deviceinfo deviceinfo) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent(deviceinfo, appColors);
      case 1:
        return MyCoursesScreen();
      case 2:
        return const ProfileScreen();
      default:
        return _buildHomeContent(deviceinfo, appColors);
    }
  }

  Widget _buildHomeContent(Deviceinfo deviceinfo, AppColors appColors) {
    return Column(
      children: [
        // App Bar
        _buildAppBar(deviceinfo, appColors),
        // Search Header
        Padding(
          padding: EdgeInsets.only(
            top: deviceinfo.screenHeight * 0.02,
            left: deviceinfo.screenWidth * 0.05,
            right: deviceinfo.screenWidth * 0.05,
          ),
          child: BlocBuilder<SearchCubit, SearchState>(
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
        ),
        Expanded(
          child: BlocBuilder<CoursesCubit, CoursesState>(
            builder: (context, coursesState) {
              if (coursesState is CoursesLoading) {
                return CourseSkeleton(deviceInfo: deviceinfo);
              } else if (coursesState is CoursesLoaded) {
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
                        deviceInfo: deviceinfo,
                      );
                    } else if (searchState is SearchLoading) {
                      return CourseSkeleton(deviceInfo: deviceinfo);
                    } else if (searchState is SearchResults) {
                      return CourseList(
                        courses: searchState.courses,
                        isSearching: true,
                        onRefresh: () {
                          context.read<CoursesCubit>().fetchCourses();
                        },
                        deviceInfo: deviceinfo,
                      );
                    } else if (searchState is SearchNoResults) {
                      return CourseList(
                        courses: const [],
                        isSearching: true,
                        onRefresh: () {
                          context.read<CoursesCubit>().fetchCourses();
                        },
                        deviceInfo: deviceinfo,
                      );
                    } else {
                      return CourseList(
                        courses: _allCourses,
                        isSearching: false,
                        onRefresh: () {
                          context.read<CoursesCubit>().fetchCourses();
                        },
                        deviceInfo: deviceinfo,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return InfoWidget(
      builder: (context, deviceinfo) => RepaintBoundary(
        child: Scaffold(
          backgroundColor: appColors.scaffoldBackground,
          body: SafeArea(
            child: Column(
              children: [Expanded(child: _buildContent(deviceinfo))],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onNavigationItemSelected,
            type: BottomNavigationBarType.shifting,
            selectedItemColor: appColors.primary,
            unselectedItemColor: appColors.tertiaryText,
            items: _navigationItems,
          ),
        ),
      ),
    );
  }
}
