// To parse this JSON data, do
//
//     final courseInfo = courseInfoFromJson(jsonString);

import 'dart:convert';

CourseInfo courseInfoFromJson(String str) =>
    CourseInfo.fromJson(json.decode(str));

String courseInfoToJson(CourseInfo data) => json.encode(data.toJson());

class CourseInfo {
  CourseInfo({
    required this.name,
    required this.week,
    required this.weekType,
    required this.timeStart,
    required this.timeEnd,
    required this.weekStart,
    required this.weekEnd,
    required this.teacher,
    required this.address,
    required this.color,
    required this.showItemLength,
  });

  String name;
  int week;
  int weekType;
  int timeStart;
  int timeEnd;
  int weekStart;
  int weekEnd;
  String teacher;
  String address;
  String color;
  int showItemLength;

  CourseInfo.empty()
      : this(
            name: '',
            week: 0,
            weekType: 0,
            timeStart: 0,
            timeEnd: 0,
            weekStart: 0,
            weekEnd: 0,
            teacher: '',
            address: '',
            color: '',
            showItemLength: 1);

  factory CourseInfo.fromJson(Map<String, dynamic> json) => CourseInfo(
        name: json["name"],
        week: json["week"],
        weekType: json["weekType"],
        timeStart: json["timeStart"],
        timeEnd: json["timeEnd"],
        weekStart: json["weekStart"],
        weekEnd: json["weekEnd"],
        teacher: json["teacher"],
        address: json["address"],
        color: json["color"] ?? '',
        showItemLength: json["showItemLength"] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "week": week,
        "weekType": weekType,
        "timeStart": timeStart,
        "timeEnd": timeEnd,
        "weekStart": weekStart,
        "weekEnd": weekEnd,
        "teacher": teacher,
        "address": address,
        "color": color,
        "showItemLength": showItemLength,
      };

  static List<List<List<CourseInfo>>> getCourseInfoList(dynamic result) {
    return List<List<List<CourseInfo>>>.from(result.map((x) =>
        List<List<CourseInfo>>.from(x.map((x) =>
            List<CourseInfo>.from(x.map((x) => CourseInfo.fromJson(x)))))));
  }
}
