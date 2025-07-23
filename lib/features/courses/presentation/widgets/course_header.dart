import 'package:edu_mate/core/Responsive/UiComponents/InfoWidget.dart';
import 'package:edu_mate/core/Responsive/models/DeviceInfo.dart';
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
    return RepaintBoundary(
      child: InfoWidget(
        builder: (context, deviceinfo) => Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: deviceinfo.screenWidth * 0.05,
            vertical: deviceinfo.screenHeight * 0.015,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.02),
            boxShadow: const [
              BoxShadow(
                color: Color(
                  0x0D000000,
                ), // Using const color instead of withOpacity
                blurRadius: 10,
                offset: Offset(0, 2),
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
    return TextField(
      controller: widget.searchController,
      focusNode: _searchFocusNode,
      decoration: InputDecoration(
        hintText: 'Search courses...',
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xFF9CA3AF),
          size: 20,
        ),
        suffixIcon:
            widget.isSearching && widget.searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: Color(0xFF9CA3AF),
                  size: 20,
                ),
                onPressed: widget.onClearSearch,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6366F1)),
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
      onTap: widget.onSearchToggle,
    );
  }

  Widget _buildSearchButton() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(Icons.search, color: Colors.white, size: 20),
        onPressed: widget.onSearchToggle,
      ),
    );
  }
}
