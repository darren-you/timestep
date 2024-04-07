import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../model/course_model.dart';
import '../my_course/my_course_page_vm.dart';
import '../repository/course_data_service.dart';
import '../course_table/timetable_vm.dart';

class CourseInfoPageViewModel extends GetxController {
  // 依赖
  final myCoursePageViewModel = Get.find<MyCoursePageViewModel>();
  final timeTableViewModel = Get.find<TimeTableViewModel>();
  final courseRepo = Get.find<CourseDataService>();
  // 界面
  final courseNameController = TextEditingController();
  late final int selectCourseIndex;

  // 被选中修改的 CourseModel 对象
  var courseModel = CourseModel.empty().obs;

  // event: 编辑课程名 -> 更新state: courseModel.name 课程名属性
  void updateCourseName() {
    courseModel.update((oldCourseModel) {
      oldCourseModel!.name = courseNameController.text;
    });
  }

  // event: 编辑时间 -> 更新state: courseModel.name 课程名属性
  void updateCourseTermStartTime(DateTime newTermStartTime) {
    courseModel.update((oldCourseModel) {
      oldCourseModel!.termStartTime = newTermStartTime;
    });
  }

  // event: 删除课程 ->
  void delCourse() {
    // 删除本地数据
    courseRepo.delCourseModel(selectCourseIndex);

    // 更新我的课表界面数据
    myCoursePageViewModel.allCourseModel.update((val) {
      val!.courseModelList.removeAt(selectCourseIndex);
    });

    // 表示课程数据发生变化
    myCoursePageViewModel.changeCourse = true;

    // 将课表界面数据置空
    timeTableViewModel.courseModel.value = CourseModel.empty();

    Get.back();
  }

  //event: 点击右上角保存
  void updateCourseData() {
    Get.back();
    updateCourseName();

    // 初始化修改后的 CourseModel 数据
    final newCourseModel = timeTableViewModel.initCourseModel(
        courseModel.value.courseData,
        courseModel.value.name,
        courseModel.value.termStartTime,
        courseModel.value.courseColor);

    // 更新我的课表界面数据
    myCoursePageViewModel.allCourseModel.update((val) {
      val!.courseModelList[selectCourseIndex] = newCourseModel;
    });

    // 表示课程数据发生变化
    myCoursePageViewModel.changeCourse = true;
  }

  @override
  void onInit() {
    selectCourseIndex = Get.arguments;
    // 初始化被选中的 CourseModel 对象
    courseModel(myCoursePageViewModel
        .allCourseModel.value.courseModelList[selectCourseIndex]
        .copyWith()); // 值拷贝，不要直接修改

    // 设置 TextFiled Widget 为课表名
    courseNameController.text = courseModel.value.name;

    super.onInit();
  }
}
