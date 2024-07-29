import 'package:date_format/date_format.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timestep/utils/date_util.dart';

import '../../../../enumm/color_enum.dart';
import '../../../../utils/color_util.dart';
import '../../model/course_model.dart';
import '../timetable_vm.dart';

/// 课程Item的高
final containerHeight = 100.0.h;

/// 绘制每周的时间信息
Container _weekTimeNav(OneWeekModel oneWeekModel, int pageIndex) {
  final viewModel = Get.find<TimeTableViewModel>();
  return Container(
    height: 26.h,
    color: Colors.transparent,
    child: Row(
      children: [
        // 月（4）
        Container(
          alignment: Alignment.center,
          width: 36.w,
          child: Text(
            oneWeekModel.month.toString(),
            style: TextStyle(
              color: oneWeekModel.month == DateTime.now().month
                  ? Colors.red
                  : Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // 一（17）、二（18）、三（19）、四（20）、五（21）、六（22）、日（23）
        Expanded(
          child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(viewModel.weekDay.value.day, (dayIndex) {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 4.w, right: 4.w, top: 4.h, bottom: 4.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: viewModel.showColor(pageIndex, dayIndex)
                          ? MyColors.cardGreen.color
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      oneWeekModel.weekTimes[dayIndex].toString(),
                      style: TextStyle(
                        // 当前日期标红
                        color: viewModel.showColor(pageIndex, dayIndex)
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              }))),
        )
      ],
    ),
  );
}

/// 绘制左侧课程时间列
SizedBox _leftTimeBar() {
  final viewModel = Get.find<TimeTableViewModel>();
  return SizedBox(
    width: 36.w,
    child: Column(
      children: List.generate(
        viewModel.courseModel.value.courseTime.length,
        (index) {
          final timeInfo = viewModel.courseModel.value.courseTime;
          return Container(
            alignment: Alignment.center,
            height: containerHeight,
            child: Column(
              children: [
                Container(
                  height: 10.h,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 5.h),
                  child: Text(
                    timeInfo[index].start,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: -0.01,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                Text(
                  '${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Expanded(child: SizedBox()),
                Container(
                  height: 10.h,
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(bottom: 5.h),
                  child: Text(
                    timeInfo[index].end,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.01,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

/// 时间线绘制
Widget _timeLineWidget(BuildContext context, int pageIndex) {
  final timeTableViewModel = Get.find<TimeTableViewModel>();
  return timeTableViewModel.nowWeek == (pageIndex + 1)
      ? Obx(
          () => Positioned(
            top: timeTableViewModel.timeLinePosition.value,
            //top: 5.h,
            //top: 85.h,
            //top: 95.h,
            child: Row(
              children: [
                Container(
                  width: 36.w,
                  height: 10.h,
                  //color: Colors.red,
                  alignment: Alignment.center,
                  child: Text(
                    timeTableViewModel.nowTime.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      height: -0.01,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
                Container(
                  width: 5.h,
                  height: 5.h,
                  //margin: EdgeInsets.only(left: 1.w),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(5.h)),
                  ),
                ),
                Container(
                  width: context.width - 36.w - 5.w - 4.w,
                  height: 1.h,
                  padding: EdgeInsets.only(right: 4.w),
                  color: Colors.red,
                ),
              ],
            ),
          ),
        )
      : const SizedBox();
}

/// 课程表格
Widget _courseItemWidget(OneWeekModel oneWeekModel) {
  final viewModel = Get.find<TimeTableViewModel>();
  return Obx(
    () => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        viewModel.weekDay.value.day,
        (day) {
          // 用Column绘制一天所有课程Item
          return Expanded(
            child: Column(
              children: oneWeekModel.courseData[day].map(
                (course) {
                  // 根据是否连课返回视图
                  if (course!.name.isEmpty) {
                    return Container(
                      color: Colors.transparent,
                      height: course.showItemLength * containerHeight,
                    );
                  } else {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
                      height: containerHeight * course.showItemLength,
                      child: Container(
                        padding: EdgeInsets.all(4.r),
                        height: containerHeight,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: HexColor(course.color, alpha: 15),
                          border: Border.all(
                            color: HexColor(course.color),
                            width: 1.h,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              course.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: HexColor(course.color)),
                            ),
                            Padding(padding: EdgeInsets.only(top: 4.h)),
                            Text(
                              '@${course.teacher}',
                              style: TextStyle(color: HexColor(course.color)),
                            ),
                            // const Padding(
                            //     padding: EdgeInsets.only(bottom: 2)),
                            Text(
                              course.address,
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  color: HexColor(course.color)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ).toList(),
            ),
          );
        },
      ),
    ),
  );
}

/// 绘制一周的所有课程Item
Expanded _courseItems(
    BuildContext context, OneWeekModel oneWeekModel, int pageIndex) {
  final viewModel = Get.find<TimeTableViewModel>();
  return Expanded(
    child: MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: SingleChildScrollView(
        controller: viewModel.courseScrollerController,
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左侧课程时间列
                _leftTimeBar(),
                Expanded(
                  child: _courseItemWidget(oneWeekModel),
                ),
              ],
            ),
            _timeLineWidget(context, pageIndex),
          ],
        ),
      ),
    ),
  );
}

class CourseWeek extends StatelessWidget {
  final OneWeekModel oneWeekModel;
  final int pageIndex;
  const CourseWeek(this.oneWeekModel, this.pageIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          // 绘制每周的时间信息
          _weekTimeNav(oneWeekModel, pageIndex),

          // 课程 Item 方块绘制
          _courseItems(context, oneWeekModel, pageIndex),
        ],
      ),
    );
  }
}
