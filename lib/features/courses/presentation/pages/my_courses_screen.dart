import 'package:edu_mate/core/Responsive/UiComponents/InfoWidget.dart';
import 'package:edu_mate/core/Responsive/models/DeviceInfo.dart';
import 'package:edu_mate/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/enrolled_course_model.dart';
import '../cubit/enrolled_courses_cubit.dart';
import '../cubit/enrolled_courses_state.dart';
import '../widgets/my_course_card.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    // Fetch enrolled courses when screen initializes
    context.read<EnrolledCoursesCubit>().fetchEnrolledCourses();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<EnrolledCourse> _getFilteredCourses() {
    final cubit = context.read<EnrolledCoursesCubit>();
    switch (_selectedTabIndex) {
      case 0: // All Courses
        return cubit.getFilteredCourses('all courses');
      case 1: // In Progress
        return cubit.getFilteredCourses('in progress');
      case 2: // Completed
        return cubit.getFilteredCourses('completed');
      default:
        return cubit.getFilteredCourses('all courses');
    }
  }

  void _toggleFavorite(int courseId) {
    context.read<EnrolledCoursesCubit>().toggleFavorite(courseId);
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return InfoWidget(
      builder: (context, deviceinfo) => Scaffold(
        backgroundColor: appColors.scaffoldBackground,
        body: SafeArea(
          child: Column(
            children: [
              _buildMainNavigationBar(deviceinfo, appColors),
              _buildCategoryTabs(deviceinfo, appColors),
              Expanded(child: _buildCourseList(deviceinfo, appColors)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainNavigationBar(Deviceinfo deviceinfo, AppColors appColors) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: deviceinfo.screenWidth * 0.05),
      padding: EdgeInsets.symmetric(
        horizontal: deviceinfo.screenWidth * 0.04,
        vertical: deviceinfo.screenHeight * 0.015,
      ),
      decoration: BoxDecoration(
        color: appColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(deviceinfo.screenWidth * 0.05),
          bottomRight: Radius.circular(deviceinfo.screenWidth * 0.05),
        ),
      ),
      child: Center(
        child: Text(
          'My Courses',
          style: TextStyle(
            color: Colors.white,
            fontSize: deviceinfo.screenWidth * 0.05,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(Deviceinfo deviceinfo, AppColors appColors) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: deviceinfo.screenWidth * 0.05),
      child: TabBar(
        controller: _tabController,
        indicatorColor: appColors.primary,
        indicatorWeight: 3,
        labelColor: appColors.primary,
        unselectedLabelColor: appColors.tertiaryText,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: deviceinfo.screenWidth * 0.02,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: deviceinfo.screenWidth * 0.02,
        ),
        tabs: const [
          Tab(text: 'All Courses'),
          Tab(text: 'In Progress'),
          Tab(text: 'Completed'),
        ],
      ),
    );
  }

  Widget _buildCourseList(Deviceinfo deviceinfo, AppColors appColors) {
    return BlocBuilder<EnrolledCoursesCubit, EnrolledCoursesState>(
      builder: (context, state) {
        if (state is EnrolledCoursesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is EnrolledCoursesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: deviceinfo.screenWidth * 0.1,
                  color: appColors.error,
                ),
                SizedBox(height: deviceinfo.screenHeight * 0.02),
                Text(
                  'Error loading courses',
                  style: TextStyle(
                    fontSize: deviceinfo.screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                    color: appColors.secondaryText,
                  ),
                ),
                SizedBox(height: deviceinfo.screenHeight * 0.01),
                Text(
                  state.message,
                  style: TextStyle(
                    fontSize: deviceinfo.screenWidth * 0.035,
                    color: appColors.tertiaryText,
                  ),
                ),
                SizedBox(height: deviceinfo.screenHeight * 0.02),
                ElevatedButton(
                  onPressed: () {
                    context.read<EnrolledCoursesCubit>().fetchEnrolledCourses();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is EnrolledCoursesLoaded) {
          final filteredCourses = _getFilteredCourses();

          if (filteredCourses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.book_outlined,
                    size: 64,
                    color: appColors.tertiaryText,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No courses found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: appColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start enrolling in courses to see them here',
                    style: TextStyle(
                      fontSize: 14,
                      color: appColors.tertiaryText,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: deviceinfo.screenWidth * 0.05,
              vertical: deviceinfo.screenHeight * 0.02,
            ),
            itemCount: filteredCourses.length,
            itemBuilder: (context, index) {
              return MyCourseCard(
                enrolledCourse: filteredCourses[index],
                onFavoriteToggle: _toggleFavorite,
                deviceInfo: deviceinfo,
              );
            },
          );
        } else {
          return const Center(child: Text('No courses available'));
        }
      },
    );
  }
}
