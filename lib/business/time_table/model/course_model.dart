import 'package:json_annotation/json_annotation.dart';

import '../../../enumm/course_enum.dart';
import '../my_course/model/course_info.dart';
import 'course_time_model.dart';

part 'course_model.g.dart';

// 存储所有课程
@JsonSerializable()
class AllCourseModel {
  List<CourseModel> courseModelList;

  AllCourseModel({
    required this.courseModelList,
  });

  AllCourseModel.empty() : this(courseModelList: []);

  // 自动生成的fromJson方法
  factory AllCourseModel.fromJson(Map<String, dynamic> json) =>
      _$AllCourseModelFromJson(json);

  // 自动生成的toJson方法
  Map<String, dynamic> toJson() => _$AllCourseModelToJson(this);
}

// 所有周课程信息
@JsonSerializable()
class CourseModel {
  List<List<List<CourseInfo>>> courseData; //课程数据
  List<OneWeekModel> courseAllPages; // 存放所有周信息
  String name; // 课程表名
  DateTime termStartTime; //用户设置的课程起始时间
  DateTime realyTermStartTime; //学期实际开始时间
  int maxWeek; // 课程最大周
  CourseItemColorEnum courseColor; // 课程Item的颜色
  List<CourseTimeModel> courseTime; //上课课程时间
  Map<String, String> courseColorMap;

  CourseModel(
      {required this.courseData,
      required this.courseAllPages,
      required this.name,
      required this.termStartTime,
      required this.realyTermStartTime,
      required this.maxWeek,
      required this.courseColor,
      List<CourseTimeModel>? courseTime,
      required this.courseColorMap})
      : courseTime = courseTime ??
            [
              CourseTimeModel("08:15", "09:00"),
              CourseTimeModel("09:05", "09:50"),
              CourseTimeModel("10:10", "10:55"),
              CourseTimeModel("11:00", "11:45"),
              CourseTimeModel("14:00", "14:45"),
              CourseTimeModel("14:50", "15:35"),
              CourseTimeModel("15:55", "16:40"),
              CourseTimeModel("16:45", "17:30"),
              CourseTimeModel("19:00", "19:45"),
              CourseTimeModel("19:50", "20:35"),
              CourseTimeModel("20:55", "21:40"),
              CourseTimeModel("21:45", "22:30"),
            ];

  CourseModel.empty()
      : this(
          courseData: [],
          courseAllPages: [],
          name: '',
          termStartTime: DateTime.now(),
          realyTermStartTime: DateTime.now(),
          maxWeek: 0,
          courseColor: CourseItemColorEnum.color_1,
          courseTime: [],
          courseColorMap: <String, String>{},
        );

  // 自动生成的fromJson方法
  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);

  // 自动生成的toJson方法
  Map<String, dynamic> toJson() => _$CourseModelToJson(this);

  CourseModel copyWith({
    List<List<List<CourseInfo?>>>? courseData,
    List<OneWeekModel>? courseAllPages,
    String? name,
    DateTime? termStartTime,
    DateTime? realyTermStartTime,
    int? maxWeek,
    CourseItemColorEnum? courseColor,
    List<CourseTimeModel>? courseTime,
    Map<String, String>? courseColorMap,
  }) {
    return CourseModel(
      courseData: this.courseData,
      courseAllPages: this.courseAllPages,
      name: this.name,
      termStartTime: this.termStartTime,
      realyTermStartTime: this.realyTermStartTime,
      maxWeek: this.maxWeek,
      courseColor: this.courseColor,
      courseTime: this.courseTime,
      courseColorMap: this.courseColorMap,
    );
  }
}

// 单周课程Model
@JsonSerializable()
class OneWeekModel {
  List<List<CourseInfo?>> courseData; //此周课程数据
  int month; //此周对应的月份
  List<int> weekTimes; //此周 一...日 对应的日期（号 D）

  OneWeekModel(this.courseData, this.month, this.weekTimes);

  // 自动生成的fromJson方法
  factory OneWeekModel.fromJson(Map<String, dynamic> json) =>
      _$OneWeekModelFromJson(json);

  // 自动生成的toJson方法
  Map<String, dynamic> toJson() => _$OneWeekModelToJson(this);
}
