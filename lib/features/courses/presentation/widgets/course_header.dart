import 'dart:math';

import 'package:edu_mate/core/Responsive/UiComponents/InfoWidget.dart';
import 'package:edu_mate/core/Responsive/models/DeviceInfo.dart';
import 'package:edu_mate/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CourseHeader extends StatefulWidget {
  final bool isSearching;
  final TextEditingController searchController;
  final VoidCallback onSearchToggle;
  final VoidCallback onClearSearch;

  const CourseHeader({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.onSearchToggle,
    required this.onClearSearch,
  });

  @override
  State<CourseHeader> createState() => _CourseHeaderState();
}

class _CourseHeaderState extends State<CourseHeader> {
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return RepaintBoundary(
      child: InfoWidget(
        builder: (context, deviceinfo) => Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: deviceinfo.screenWidth * 0.05,
            vertical: deviceinfo.screenHeight * 0.015,
          ),
          decoration: BoxDecoration(
            color: appColors.cardBackground,
            borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.02),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(child: _buildSearchField(deviceinfo)),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(Deviceinfo deviceinfo) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return TextField(
      controller: widget.searchController,
      focusNode: _searchFocusNode,
      onTapOutside: (_) {
        FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        hintText: 'Search courses...',
        hintStyle: TextStyle(
          color: appColors.tertiaryText,
          fontSize: deviceinfo.screenWidth * 0.04,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: appColors.tertiaryText,
          size: deviceinfo.screenWidth * 0.04,
        ),
        suffixIcon:
            widget.isSearching && widget.searchController.text.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                  color: appColors.tertiaryText,
                  size: deviceinfo.screenWidth * 0.04,
                ),
                onPressed: widget.onClearSearch,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.02),
          borderSide: BorderSide(color: appColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.02),
          borderSide: BorderSide(color: appColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.02),
          borderSide: BorderSide(color: appColors.primary),
        ),
        filled: true,
        fillColor: appColors.inputBackground,
        contentPadding: EdgeInsets.symmetric(
          horizontal: deviceinfo.screenWidth * 0.02,
          vertical: deviceinfo.screenHeight * 0.015,
        ),
      ),
      style: TextStyle(fontSize: 14, color: appColors.primaryText),
      onTap: widget.onSearchToggle,
    );
  }
}
