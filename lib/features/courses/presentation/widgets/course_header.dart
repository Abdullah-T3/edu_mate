import 'package:edu_mate/core/Responsive/UiComponents/InfoWidget.dart';
import 'package:flutter/material.dart';
import '../../data/models/courses_model.dart';

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

class _CourseHeaderState extends State<CourseHeader>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  AnimationController? _searchAnimationController;
  Animation<double>? _searchAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _searchAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _searchAnimationController!,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void didUpdateWidget(CourseHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSearching != oldWidget.isSearching &&
        _searchAnimationController != null) {
      if (widget.isSearching) {
        _searchAnimationController!.forward();
      } else {
        _searchAnimationController!.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 10 * (1 - _animation.value)),
          child: Opacity(
            opacity: _animation.value,
            child: InfoWidget(
              builder: (context, deviceinfo) => Container(
                width: deviceinfo.screenWidth * 0.8,
                padding: EdgeInsets.symmetric(
                  horizontal: deviceinfo.screenWidth * 0.05,
                  vertical: deviceinfo.screenHeight * 0.02,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(0, -0.3),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeInOut,
                                ),
                              ),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                  child: widget.isSearching
                      ? _buildFullWidthSearchField()
                      : _buildNormalHeader(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNormalHeader() {
    return Row(
      key: const ValueKey('normal_header'),
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          child: Text(
            'Courses',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        const Spacer(),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: widget.onSearchToggle,
            icon: AnimatedRotation(
              duration: const Duration(milliseconds: 300),
              turns: 0,
              child: Icon(
                Icons.search,
                color: const Color(0xFF6366F1),
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullWidthSearchField() {
    return AnimatedContainer(
      key: const ValueKey('search_field'),
      duration: const Duration(milliseconds: 300),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: widget.searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search courses...',
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              key: ValueKey(widget.searchController.text.isEmpty),
              onPressed: widget.onClearSearch,
              icon: AnimatedRotation(
                duration: const Duration(milliseconds: 200),
                turns: widget.searchController.text.isEmpty ? 0 : 0.25,
                child: Icon(Icons.close, color: Colors.grey[600], size: 22),
              ),
            ),
          ),
          prefixIcon: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Icon(Icons.search, color: const Color(0xFF6366F1), size: 22),
          ),
        ),
        style: const TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
      ),
    );
  }
}
