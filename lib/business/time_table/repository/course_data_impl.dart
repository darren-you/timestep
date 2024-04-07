import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../enumm/course_enum.dart';
import '../../../enumm/storage_key_enum.dart';
import '../../../utils/storage_util.dart';
import '../model/course_model.dart';
import 'course_data_service.dart';

class CourseDataImpl extends GetxService implements CourseDataService {
  @override
  void addCourseModel(CourseModel newCourseModel) {
    // 先读取出本地所有课程数据，再存储
    final allCourseModel = getAllCourseModel();
    allCourseModel.courseModelList.add(newCourseModel);

    saveAllCourseModel(allCourseModel);
  }

  @override
  void delCourseModel(int delIndex) {
    final allCourseModel = getAllCourseModel();
    final courseName = allCourseModel.courseModelList[delIndex].name;
    allCourseModel.courseModelList.removeAt(delIndex);
    saveAllCourseModel(allCourseModel);
    debugPrint('删除课表 $courseName 成功');
  }

  @override
  AllCourseModel getAllCourseModel() {
    // 判断本地有无课程数据
    if (GetStorageUtil.hasData(CourseStorageKeyEnum.courseData.key)) {
      final allCourseModel = AllCourseModel.fromJson(jsonDecode(
          GetStorageUtil.readData(CourseStorageKeyEnum.courseData.key)));

      allCourseModel.courseModelList.isEmpty
          ? debugPrint("无本地课程数据❌")
          : debugPrint("存在 ${allCourseModel.courseModelList.length} 个本地课程数据✅");

      return allCourseModel;
    }

    return AllCourseModel.empty();
  }

  @override
  ChangeCourseEnum getChangeCourse() {
    if (GetStorageUtil.hasData(CourseStorageKeyEnum.changeCourse.key)) {
      final changeCourseState =
          GetStorageUtil.readData(CourseStorageKeyEnum.changeCourse.key);

      debugPrint("存在✅是否开启快捷切换课表数据: $changeCourseState");

      return changeCourseState == 0
          ? ChangeCourseEnum.off
          : ChangeCourseEnum.on;
    }

    debugPrint("不存在❌是否开启快捷切换课表数据");

    return ChangeCourseEnum.off;
  }

  @override
  OneWeekDayEnum getShowWeekend() {
    if (GetStorageUtil.hasData(CourseStorageKeyEnum.showWeekDay.key)) {
      final weekDay =
          GetStorageUtil.readData(CourseStorageKeyEnum.showWeekDay.key);

      debugPrint("存在✅本地一周显示多少天课程数据: $weekDay");

      return weekDay == 5 ? OneWeekDayEnum.week5 : OneWeekDayEnum.week7;
    }

    debugPrint("不存在❌本地一周显示多少天课程数据");

    return OneWeekDayEnum.week5;
  }

  @override
  void saveAllCourseModel(AllCourseModel newAllCourseModel) {
    GetStorageUtil.writeData(
        CourseStorageKeyEnum.courseData.key, jsonEncode(newAllCourseModel));

    debugPrint("存储/更新 > > > 本地课程数据完成✅");
  }

  @override
  void saveChangeCourse(ChangeCourseEnum changeCourseEnum) {
    GetStorageUtil.writeData(
        CourseStorageKeyEnum.changeCourse.key, changeCourseEnum.state);
    debugPrint("存储 > > > 是否开启快捷切换课表 ${changeCourseEnum.state} 数据完成✅");
  }

  @override
  void saveShowWeekend(OneWeekDayEnum oneWeekDayEnum) {
    GetStorageUtil.writeData(
        CourseStorageKeyEnum.showWeekDay.key, oneWeekDayEnum.day);
    debugPrint("存储 > > > 一周显示 ${oneWeekDayEnum.day} 天课程数据完成✅");
  }

  @override
  void updateCourseModel(int index, CourseModel newCourseModel) {
    final allCourseModel = getAllCourseModel();
    allCourseModel.courseModelList[index] = newCourseModel;

    saveAllCourseModel(allCourseModel);
  }
}
