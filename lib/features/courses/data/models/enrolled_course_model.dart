// To parse this JSON data, do
//
//     final enrolledCourse = enrolledCourseFromJson(jsonList);

import 'dart:convert';

import 'package:edu_mate/features/courses/data/models/courses_model.dart';

List<EnrolledCourse> enrolledCourseFromJson(List<dynamic> jsonList) =>
    List<EnrolledCourse>.from(jsonList.map((x) => EnrolledCourse.fromJson(x)));

String enrolledCourseToJson(List<EnrolledCourse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EnrolledCourse {
  Course course;
  int progress;
  bool isFavorite;

  EnrolledCourse({
    required this.course,
    required this.progress,
    required this.isFavorite,
  });

  factory EnrolledCourse.fromJson(Map<String, dynamic> json) => EnrolledCourse(
    course: json["course"] != null
        ? Course.fromJson(json["course"])
        : Course(
            id: 0,
            title: "",
            description: "",
            category: "",
            image: "",
            video: "",
            rating: 0.0,
            instructor: Instructor(name: "", title: ""),
            duration: "",
            courseContent: [],
          ),
    progress: json["progress"] ?? 0,
    isFavorite: json["isFavorite"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "course": course.toJson(),
    "progress": progress,
    "isFavorite": isFavorite,
  };

  EnrolledCourse copyWith({Course? course, int? progress, bool? isFavorite}) {
    return EnrolledCourse(
      course: course ?? this.course,
      progress: progress ?? this.progress,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
