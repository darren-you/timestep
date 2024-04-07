// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllCourseModel _$AllCourseModelFromJson(Map<String, dynamic> json) =>
    AllCourseModel(
      courseModelList: (json['courseModelList'] as List<dynamic>)
          .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllCourseModelToJson(AllCourseModel instance) =>
    <String, dynamic>{
      'courseModelList': instance.courseModelList,
    };

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => CourseModel(
      courseData: (json['courseData'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => (e as List<dynamic>)
                  .map((e) => CourseInfo.fromJson(e as Map<String, dynamic>))
                  .toList())
              .toList())
          .toList(),
      courseAllPages: (json['courseAllPages'] as List<dynamic>)
          .map((e) => OneWeekModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String,
      termStartTime: DateTime.parse(json['termStartTime'] as String),
      realyTermStartTime: DateTime.parse(json['realyTermStartTime'] as String),
      maxWeek: json['maxWeek'] as int,
      courseColor:
          $enumDecode(_$CourseItemColorEnumEnumMap, json['courseColor']),
      courseTime: (json['courseTime'] as List<dynamic>?)
          ?.map((e) => CourseTimeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      courseColorMap: Map<String, String>.from(json['courseColorMap'] as Map),
    );

Map<String, dynamic> _$CourseModelToJson(CourseModel instance) =>
    <String, dynamic>{
      'courseData': instance.courseData,
      'courseAllPages': instance.courseAllPages,
      'name': instance.name,
      'termStartTime': instance.termStartTime.toIso8601String(),
      'realyTermStartTime': instance.realyTermStartTime.toIso8601String(),
      'maxWeek': instance.maxWeek,
      'courseColor': _$CourseItemColorEnumEnumMap[instance.courseColor]!,
      'courseTime': instance.courseTime,
      'courseColorMap': instance.courseColorMap,
    };

const _$CourseItemColorEnumEnumMap = {
  CourseItemColorEnum.color_1: 'color_1',
  CourseItemColorEnum.color_2: 'color_2',
};

OneWeekModel _$OneWeekModelFromJson(Map<String, dynamic> json) => OneWeekModel(
      (json['courseData'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => e == null
                  ? null
                  : CourseInfo.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
      json['month'] as int,
      (json['weekTimes'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$OneWeekModelToJson(OneWeekModel instance) =>
    <String, dynamic>{
      'courseData': instance.courseData,
      'month': instance.month,
      'weekTimes': instance.weekTimes,
    };
