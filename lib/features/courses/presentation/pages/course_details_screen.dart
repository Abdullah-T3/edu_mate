import 'package:edu_mate/core/Responsive/UiComponents/InfoWidget.dart';
import 'package:edu_mate/core/Responsive/models/DeviceInfo.dart';
import 'package:edu_mate/core/helper/cherryToast/CherryToastMsgs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../data/models/courses_model.dart';

class CourseDetailsScreen extends StatefulWidget {
  final Course course;

  const CourseDetailsScreen({super.key, required this.course});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  YoutubePlayerController? _youtubePlayerController;
  bool _isVideoPlaying = false;
  bool _isVideoLoading = false;
  bool _youtubePlayerAvailable = true;

  @override
  void initState() {
    super.initState();
    print(
      'Initializing course details screen for course: ${widget.course.title}',
    );
    print('Video URL: ${widget.course.video}');
    // Delay initialization to ensure widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeYoutubePlayer();
    });
  }

  @override
  void dispose() {
    _youtubePlayerController?.dispose();
    super.dispose();
  }

  String? _extractVideoId(String url) {
    try {
      // Try the package's method first
      final videoId = YoutubePlayer.convertUrlToId(url);
      if (videoId != null && videoId.isNotEmpty) {
        return videoId;
      }

      // Fallback: manual extraction
      final uri = Uri.parse(url);
      if (uri.host.contains('youtube.com') || uri.host.contains('youtu.be')) {
        if (uri.host.contains('youtu.be')) {
          return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
        } else {
          return uri.queryParameters['v'];
        }
      }
      return null;
    } catch (e) {
      print('Error extracting video ID: $e');
      return null;
    }
  }

  void _initializeYoutubePlayer() {
    try {
      if (widget.course.video.isNotEmpty) {
        final videoId = _extractVideoId(widget.course.video);
        if (videoId != null && videoId.isNotEmpty) {
          _youtubePlayerController = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
              isLive: false,
              enableCaption: false,
              forceHD: false,
              hideControls: false,
              showLiveFullscreenButton: false,
            ),
          );
          print(
            'YouTube player initialized successfully with video ID: $videoId',
          );
        } else {
          print('Invalid YouTube URL or could not extract video ID');
          _youtubePlayerController = null;
          _youtubePlayerAvailable = false;
        }
      } else {
        _youtubePlayerController = null;
        _youtubePlayerAvailable = false;
      }
    } catch (e) {
      print('Error initializing YouTube player: $e');
      _youtubePlayerController = null;
      _youtubePlayerAvailable = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: InfoWidget(
          builder: (context, deviceinfo) => Column(
            children: [
              // Header
              _buildHeader(context),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    spacing: deviceinfo.screenHeight * 0.02,
                    children: [
                      // Video Player Section
                      _buildVideoSection(context, deviceinfo),

                      _buildCourseInfoCard(context, deviceinfo),

                      // Instructor Section
                      _buildInstructorSection(context, deviceinfo),

                      // About Course Section
                      _buildAboutCourseSection(context, deviceinfo),

                      // Course Content Section
                      _buildCourseContentSection(context, deviceinfo),

                      SizedBox(
                        height: deviceinfo.screenHeight * 0.02,
                      ), // Spacing at the bottom
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF6A85F1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Expanded(
            child: Text(
              'Course Details',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 48), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildVideoSection(BuildContext context, Deviceinfo deviceinfo) {
    // Show YouTube player if available and playing
    if (_youtubePlayerAvailable &&
        _youtubePlayerController != null &&
        _isVideoPlaying) {
      return Container(
        margin: const EdgeInsets.all(20),
        height: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Builder(
            builder: (context) {
              try {
                return YoutubePlayer(
                  controller: _youtubePlayerController!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: const Color(0xFF6A85F1),
                  progressColors: const ProgressBarColors(
                    playedColor: Color(0xFF6A85F1),
                    handleColor: Color(0xFF6A85F1),
                  ),
                  onEnded: (YoutubeMetaData metaData) {
                    setState(() {
                      _isVideoPlaying = false;
                    });
                  },
                  onReady: () {
                    print('YouTube player is ready');
                  },
                );
              } catch (e) {
                print('Error creating YouTube player widget: $e');
                // Fallback to URL launcher
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isVideoPlaying = false;
                    _youtubePlayerAvailable = false;
                  });
                  _openVideoOnYouTube(deviceinfo);
                });
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[300],
                  ),
                  child: const Center(child: Text('Loading video...')),
                );
              }
            },
          ),
        ),
      );
    }

    // Show video preview with play button
    return Container(
      margin: const EdgeInsets.all(20),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: _getCourseGradient(widget.course.category),
      ),
      child: Stack(
        children: [
          // Background image or placeholder
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          // Play button
          Center(
            child: GestureDetector(
              onTap: _isVideoLoading
                  ? null
                  : () => _handleVideoPlay(deviceinfo),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _isVideoLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF6A85F1),
                        ),
                      )
                    : Icon(
                        Icons.play_arrow,
                        color: _getGradientColors(widget.course.category).first,
                        size: 40,
                      ),
              ),
            ),
          ),
          // Video title overlay
          if (widget.course.video.isNotEmpty)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _youtubePlayerAvailable
                      ? 'Tap to watch video'
                      : 'Tap to watch on YouTube',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleVideoPlay(Deviceinfo deviceinfo) {
    try {
      if (_youtubePlayerAvailable && _youtubePlayerController != null) {
        setState(() {
          _isVideoPlaying = true;
        });
      } else {
        _openVideoOnYouTube(deviceinfo);
      }
    } catch (e) {
      print('Error starting video: $e');
      setState(() {
        _youtubePlayerAvailable = false;
      });
      _openVideoOnYouTube(deviceinfo);
    }
  }

  Future<void> _openVideoOnYouTube(Deviceinfo deviceinfo) async {
    if (widget.course.video.isEmpty) {
      CherryToastMsgs.CherryToastError(
        info: deviceinfo,
        context: context,
        title: 'Error',
        description: 'No video URL available for this course.',
      );
      return;
    }

    setState(() {
      _isVideoLoading = true;
    });

    try {
      final Uri url = Uri.parse(widget.course.video);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        CherryToastMsgs.CherryToastError(
          info: deviceinfo,
          context: context,
          title: 'Error',
          description:
              'Could not launch video URL. Please check the URL and try again.',
        );
      }
    } catch (e) {
      print('Error opening video: $e');
      CherryToastMsgs.CherryToastError(
        info: deviceinfo,
        context: context,
        title: 'Error',
        description:
            'An error occurred while trying to open the video. Please try again later.',
      );
    } finally {
      setState(() {
        _isVideoLoading = false;
      });
    }
  }

  Widget _buildCourseInfoCard(BuildContext context, Deviceinfo deviceinfo) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: deviceinfo.screenWidth * 0.05),
      padding: EdgeInsets.all(deviceinfo.screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: deviceinfo.screenWidth * 0.05,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.course.title,
            style: TextStyle(
              fontSize: deviceinfo.screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: deviceinfo.screenHeight * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(
                Icons.star,
                widget.course.rating.toString(),
                Colors.amber,
                deviceinfo,
              ),
              _buildInfoItem(
                Icons.access_time,
                widget.course.duration,
                Colors.grey,
                deviceinfo,
              ),
              _buildInfoItem(
                Icons.people,
                '2.5k students',
                Colors.blue,
                deviceinfo,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String text,
    Color iconColor,
    Deviceinfo deviceinfo,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(icon, size: deviceinfo.screenWidth * 0.08, color: iconColor),
        SizedBox(width: deviceinfo.screenWidth * 0.01),
        Text(
          text,
          style: TextStyle(
            fontSize: deviceinfo.screenWidth * 0.03,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructorSection(BuildContext context, Deviceinfo deviceinfo) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: deviceinfo.screenWidth * 0.05),
      padding: EdgeInsets.all(deviceinfo.screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: deviceinfo.screenWidth * 0.05,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: deviceinfo.screenWidth * 0.08,
            backgroundColor: const Color(0xFF6A85F1),
            child: Text(
              widget.course.instructor.name.substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: deviceinfo.screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: deviceinfo.screenWidth * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.course.instructor.name,
                  style: TextStyle(
                    fontSize: deviceinfo.screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.course.instructor.title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCourseSection(BuildContext context, Deviceinfo deviceinfo) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: deviceinfo.screenWidth * 0.05),
      padding: EdgeInsets.all(deviceinfo.screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(deviceinfo.screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: deviceinfo.screenWidth * 0.05,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this course',
            style: TextStyle(
              fontSize: deviceinfo.screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: deviceinfo.screenHeight * 0.01),
          Text(
            widget.course.description,
            style: TextStyle(
              fontSize: deviceinfo.screenWidth * 0.04,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          SizedBox(height: deviceinfo.screenHeight * 0.02),
          ElevatedButton.icon(
            onPressed: () => _openVideoOnYouTube(deviceinfo),
            icon: const Icon(Icons.play_arrow, color: Colors.white),
            label: const Text(
              'Watch Video on YouTube',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              minimumSize: Size(
                deviceinfo.screenWidth * 0.8,
                deviceinfo.screenHeight * 0.06,
              ),
              padding: EdgeInsets.symmetric(
                vertical: deviceinfo.screenHeight * 0.01,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  deviceinfo.screenWidth * 0.04,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseContentSection(
    BuildContext context,
    Deviceinfo deviceinfo,
  ) {
    final lessons = widget.course.courseContent.toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
            'Course Content',
            style: TextStyle(
              fontSize: deviceinfo.screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: deviceinfo.screenHeight * 0.01),
          ...lessons.asMap().entries.map((entry) {
            int lessonNumber = entry.key + 1;
            String title = entry.value;
            return _buildLessonItem(lessonNumber, title);
          }),
        ],
      ),
    );
  }

  Widget _buildLessonItem(int lessonNumber, String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF6A85F1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.play_arrow, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lesson $lessonNumber: $title',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }

  LinearGradient _getCourseGradient(String category) {
    final colors = _getGradientColors(category);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }

  List<Color> _getGradientColors(String category) {
    switch (category.toLowerCase()) {
      case 'programming':
        return [const Color(0xFF8B5CF6), const Color(0xFF1E40AF)];
      case 'design':
        return [const Color(0xFFEC4899), const Color(0xFF8B5CF6)];
      case 'data science':
        return [const Color(0xFF3B82F6), const Color(0xFF0D9488)];
      default:
        return [const Color(0xFF6366F1), const Color(0xFF1E40AF)];
    }
  }
}
