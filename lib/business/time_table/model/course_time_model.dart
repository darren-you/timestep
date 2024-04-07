import 'package:json_annotation/json_annotation.dart';

part 'course_time_model.g.dart';

@JsonSerializable()
class CourseTimeModel {
  String start;
  String end;

  CourseTimeModel(this.start, this.end);

  // 自动生成的fromJson方法
  factory CourseTimeModel.fromJson(Map<String, dynamic> json) =>
      _$CourseTimeModelFromJson(json);

  // 自动生成的toJson方法
  Map<String, dynamic> toJson() => _$CourseTimeModelToJson(this);
}
