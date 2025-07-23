// import 'package:edu_mate/core/Responsive/models/DeviceInfo.dart';
// import 'package:flutter/material.dart';
// import 'package:injectable/injectable.dart';

// class BottomNavigation extends StatefulWidget {
//   final int selectedIndex;
//   final Function(int) onItemSelected;
//   final Deviceinfo deviceinfo;
//   const BottomNavigation({
//     super.key,
//     required this.selectedIndex,
//     required this.onItemSelected,
//     required this.deviceinfo,
//   });

//   @override
//   State<BottomNavigation> createState() => _BottomNavigationState();
// }

// class _BottomNavigationState extends State<BottomNavigation> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: widget.deviceinfo.screenWidth * 0.01,
//             spreadRadius: widget.deviceinfo.screenWidth * 0.005,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: widget.deviceinfo.screenWidth * 0.05,
//             vertical: widget.deviceinfo.screenHeight * 0.01,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildNavItem(0, Icons.home_rounded, 'Home'),
//               _buildNavItem(1, Icons.book_rounded, 'My Courses'),
//               _buildNavItem(2, Icons.person_rounded, 'Profile'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem(int index, IconData icon, String label) {
//     final isSelected = widget.selectedIndex == index;
//     return GestureDetector(
//       onTap: () => widget.onItemSelected(index),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: EdgeInsets.symmetric(
//           vertical: widget.deviceinfo.screenHeight * 0.01,
//           horizontal: widget.deviceinfo.screenWidth * 0.04,
//         ),
//         decoration: BoxDecoration(
//           color: isSelected
//               ? const Color(0xFF6366F1).withOpacity(0.1)
//               : Colors.transparent,
//           borderRadius: BorderRadius.circular(
//             widget.deviceinfo.screenWidth * 0.02,
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? const Color(0xFF6366F1) : Colors.grey[400],
//               size: widget.deviceinfo.screenWidth * 0.07,
//             ),
//             SizedBox(height: widget.deviceinfo.screenHeight * 0.005),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: widget.deviceinfo.screenWidth * 0.035,
//                 fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
//                 color: isSelected ? const Color(0xFF6366F1) : Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
