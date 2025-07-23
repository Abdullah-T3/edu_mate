// To parse this JSON data, do
//
//     final course = courseFromJson(jsonString);

import 'dart:convert';

List<Course> courseFromJson(String str) =>
    List<Course>.from(json.decode(str).map((x) => Course.fromJson(x)));

String courseToJson(List<Course> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Course {
  int id;
  String title;
  String description;
  String category;
  String image;
  String video;
  double rating;
  Instructor instructor;
  String duration;
  List<String> courseContent;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.image,
    required this.video,
    required this.rating,
    required this.instructor,
    required this.duration,
    required this.courseContent,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json["id"] ?? 0,
    title: json["title"] ?? "",
    description: json["description"] ?? "",
    category: json["category"] ?? "",
    image: json["image"] ?? "",
    video: json["video"] ?? "",
    rating: json["rating"]?.toDouble() ?? 0.0,
    instructor: json["instructor"] != null
        ? Instructor.fromJson(json["instructor"])
        : Instructor(name: "", title: ""),
    duration: json["duration"] ?? "",
    courseContent: json["course_content"] != null
        ? List<String>.from(json["course_content"].map((x) => x))
        : <String>[],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "category": category,
    "image": image,
    "video": video,
    "rating": rating,
    "instructor": instructor.toJson(),
    "duration": duration,
    "course_content": List<dynamic>.from(courseContent.map((x) => x)),
  };
}

class Instructor {
  String name;
  String title;

  Instructor({required this.name, required this.title});

  factory Instructor.fromJson(Map<String, dynamic> json) =>
      Instructor(name: json["name"] ?? "", title: json["title"] ?? "");

  Map<String, dynamic> toJson() => {"name": name, "title": title};
}
