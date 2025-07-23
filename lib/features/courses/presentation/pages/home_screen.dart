import 'package:edu_mate/core/Responsive/UiComponents/InfoWidget.dart';
import 'package:edu_mate/core/Responsive/models/DeviceInfo.dart';
import 'package:edu_mate/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edu_mate/features/auth/presentation/pages/profile_screen.dart';

import '../../data/models/courses_model.dart';
import '../cubit/courses_cubit.dart';
import '../cubit/search_cubit.dart';
import '../widgets/course_header.dart';
import '../widgets/course_list.dart';
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

  Widget _buildContent(Deviceinfo deviceinfo) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent(deviceinfo, appColors);
      case 1:
        return _buildMyCoursesContent(deviceinfo);
      case 2:
        return ProfileScreen();
      default:
        return _buildHomeContent(deviceinfo, appColors);
    }
  }

  Widget _buildHomeContent(Deviceinfo deviceinfo, AppColors appColors) {
    return Column(
      children: [
        // Header with proper spacing
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
                return Center(
                  child: CircularProgressIndicator(color: appColors.primary),
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
                        deviceInfo: deviceinfo,
                      );
                    } else if (searchState is SearchLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: appColors.primary,
                        ),
                      );
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
                        courses: [],
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

  Widget _buildMyCoursesContent(Deviceinfo deviceinfo) {
    return const Center(
      child: Text(
        'My Courses',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return InfoWidget(
      builder: (context, deviceinfo) => Scaffold(
        backgroundColor: appColors.scaffoldBackground,
        body: SafeArea(
          child: Column(children: [Expanded(child: _buildContent(deviceinfo))]),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onNavigationItemSelected,
          type: BottomNavigationBarType.shifting,
          selectedItemColor: appColors.primary,
          unselectedItemColor: appColors.tertiaryText,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_rounded),
              label: 'My Courses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
          // bottomNavigationBar: BottomNavigation(
          //   selectedIndex: _selectedIndex,
          //   onItemSelected: _onNavigationItemSelected,
          //   deviceinfo: deviceinfo,
          // ),
        ),
      ),
    );
  }
}
