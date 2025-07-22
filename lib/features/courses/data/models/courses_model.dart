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

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.image,
    required this.video,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    category: json["category"],
    image: json["image"],
    video: json["video"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "category": category,
    "image": image,
    "video": video,
  };
}
