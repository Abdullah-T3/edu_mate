import 'package:edu_mate/core/Responsive/UiComponents/InfoWidget.dart';
import 'package:edu_mate/core/Responsive/models/DeviceInfo.dart';
import 'package:edu_mate/core/di/injection.dart';
import 'package:edu_mate/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/routs.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/logic/theme_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  @override
  void initState() {
    getIt<AuthCubit>().checkAuthentication();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Scaffold(
      backgroundColor: appColors.scaffoldBackground,
      body: SafeArea(
        child: InfoWidget(
          builder: (context, deviceinfo) => Column(
            children: [
              _buildHeader(context, deviceinfo),

              _buildProfileInfoSection(context, deviceinfo),

              _buildStatisticsSection(context),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildAccountSettingsSection(context),
                      _buildAppSettingsSection(context),
                      _buildSupportSection(context),
                      SizedBox(height: deviceinfo.screenHeight * 0.02),
                    ],
                  ),
                ),
              ),

              // Sign Out Button
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Deviceinfo deviceinfo) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: deviceinfo.screenWidth * 0.05,
        vertical: deviceinfo.screenHeight * 0.02,
      ),
      decoration: BoxDecoration(
        color: appColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(deviceinfo.screenWidth * 0.05),
          bottomRight: Radius.circular(deviceinfo.screenWidth * 0.05),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: deviceinfo.screenWidth * 0.08),
          Expanded(
            child: Text(
              'Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appColors.cardBackground,
                fontSize: deviceinfo.screenWidth * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              _showSignOutDialog(context);
            },
            icon: Icon(Icons.logout, color: appColors.error),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoSection(BuildContext context, Deviceinfo deviceinfo) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = (state is Authenticated) ? state.user : null;
        if (user == null) {
          return Center(
            child: Text(
              'Please log in to view your profile',
              style: TextStyle(color: appColors.primaryText, fontSize: 16),
            ),
          );
        }
        return Container(
          padding: EdgeInsets.all(deviceinfo.screenWidth * 0.05),
          decoration: BoxDecoration(
            color: appColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(deviceinfo.screenWidth * 0.05),
              bottomRight: Radius.circular(deviceinfo.screenWidth * 0.05),
            ),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: deviceinfo.screenWidth * 0.15,
                    backgroundColor: appColors.cardBackground.withOpacity(0.2),
                    child: Icon(
                      Icons.person,
                      size: deviceinfo.screenWidth * 0.15,
                      color: appColors.cardBackground,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: deviceinfo.screenWidth * 0.08,
                      height: deviceinfo.screenWidth * 0.08,
                      decoration: BoxDecoration(
                        color: appColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: appColors.cardBackground,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.edit,
                        size: deviceinfo.screenWidth * 0.04,
                        color: appColors.cardBackground,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: deviceinfo.screenHeight * 0.02),
              Text(
                user.displayName ?? '',
                style: TextStyle(
                  color: appColors.cardBackground,
                  fontSize: deviceinfo.screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: deviceinfo.screenHeight * 0.01),
              Text(
                user.email ?? '',
                style: TextStyle(
                  color: appColors.cardBackground.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatisticsSection(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('12', 'Courses'),
          _buildStatItem('8', 'Completed'),
          _buildStatItem('156h', 'Learning Time'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Builder(
      builder: (context) {
        final appColors = Theme.of(context).extension<AppColors>()!;

        return Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: appColors.primaryText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: appColors.tertiaryText),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAccountSettingsSection(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: appColors.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.person,
            title: 'Edit Profile',
            onTap: () {
              // Handle edit profile
            },
          ),
          Divider(color: appColors.divider),
          _buildSettingItem(
            icon: Icons.lock,
            title: 'Change Password',
            onTap: () {
              // Handle change password
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsSection(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'App Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: appColors.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return _buildSettingItem(
                icon: Icons.dark_mode,
                title: 'Dark Theme',
                trailing: Switch(
                  value: themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    context.read<ThemeCubit>().changeTheme();
                  },
                  activeColor: appColors.primary,
                ),
              );
            },
          ),
          Divider(color: appColors.divider),
          _buildSettingItem(
            icon: Icons.notifications,
            title: 'Notifications',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
              activeColor: appColors.primary,
            ),
          ),
          Divider(color: appColors.divider),
          _buildSettingItem(
            icon: Icons.download,
            title: 'Download Quality',
            subtitle: 'HD',
            onTap: () {
              // Handle download quality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: appColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Support',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: appColors.primaryText,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            icon: Icons.help,
            title: 'Help Center',
            onTap: () {
              // Handle help center
            },
          ),
          Divider(color: appColors.divider),
          _buildSettingItem(
            icon: Icons.email,
            title: 'Contact Us',
            onTap: () {
              // Handle contact us
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Builder(
      builder: (context) {
        final appColors = Theme.of(context).extension<AppColors>()!;

        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: appColors.primary, size: 20),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: appColors.primaryText,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: appColors.tertiaryText,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null)
                  trailing
                else
                  Icon(Icons.chevron_right, color: appColors.tertiaryText),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                getIt<AuthCubit>().logout();
                Navigator.of(context).pop();
                // Handle sign out
                context.go(Routes.loginScreen);
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}
