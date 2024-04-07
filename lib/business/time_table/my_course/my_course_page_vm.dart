import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../course_table/timetable_vm.dart';
import '../model/course_model.dart';
import '../../../utils/page_path_util.dart';
import '../repository/course_data_service.dart';

class MyCoursePageViewModel extends GetxController {
  // 依赖
  final _courseRepo = Get.find<CourseDataService>();
  final _timeTableViewModel = Get.find<TimeTableViewModel>();
  var allCourseModel = AllCourseModel.empty().obs; // 所有课程信息Model
  // 界面相关
  // 标记课表是否发生了改变
  var changeCourse = false;

  // event: 页面启动 -> 获取本地课程，用于显示为列表
  void getAllCourseModel() {
    // 更新状态
    allCourseModel(_courseRepo.getAllCourseModel());
  }

  // event: 关闭页面 -> [如果课程数据发生了改变]保存课表数据 / 更新状态
  void _updateAllCourseModel() {
    if (changeCourse) {
      debugPrint("课程数据发生了改变 > > > 保存课表数据 / 更新状态");
      _courseRepo.saveAllCourseModel(allCourseModel.value);
      _timeTableViewModel.initPageState();
      _timeTableViewModel.toNowWeekPage(animate: false);
    } else {
      debugPrint("课程数据未改变 > > > ");
    }
  }

  // event: 拖动课程Item -> 更新排序后的列表 state，更新缓存变量
  void reorderCourse(int oldIndex, int newIndex) {
    allCourseModel.update((oldCourseModel) {
      final CourseModel courseModel = oldCourseModel!.courseModelList
          .removeAt(oldIndex); // 被移动的 CourseModel

      oldCourseModel.courseModelList
          .insert(newIndex, courseModel); // 直接插入到newIndex处
    });

    changeCourse = true;
  }

  // event: 点击单个课程表的时候响应
  void updateCourseModel(int index) {
    Get.toNamed(PagePathUtil.courseUpdatePage, arguments: index);
  }

  // event: 进入页面，若无课程表则，自动弹起导入

  @override
  void onInit() {
    getAllCourseModel();

    super.onInit();
  }

  @override
  void onClose() {
    _updateAllCourseModel();

    super.onClose();
  }
}
