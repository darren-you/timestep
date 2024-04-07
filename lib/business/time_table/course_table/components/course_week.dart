import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../enumm/color_enum.dart';
import '../../../../utils/color_util.dart';
import '../../model/course_model.dart';
import '../timetable_vm.dart';

// 课程Item的高
const containerHeight = 90.0;

// 绘制每周的时间信息
Container weekTimeNav(OneWeekModel oneWeekModel, int pageIndex) {
  final viewModel = Get.find<TimeTableViewModel>();
  return Container(
    height: 26,
    color: Colors.transparent,
    child: Row(
      children: [
        // 月（4）
        Container(
          alignment: Alignment.center,
          width: 36,
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
                    margin: const EdgeInsets.only(
                        left: 4, right: 4, top: 4, bottom: 4),
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

// 绘制左侧课程时间列
SizedBox leftTimeBar() {
  final viewModel = Get.find<TimeTableViewModel>();
  return SizedBox(
    width: 36,
    child: Column(
      children: List.generate(
        viewModel.courseModel.value.courseTime.length ~/ 2,
        (index) {
          final timeInfo = viewModel.courseModel.value.courseTime;
          index = index * 2;
          return Container(
            alignment: Alignment.center,
            height: containerHeight * 2,
            // color: Color.fromARGB(Random().nextInt(255), Random().nextInt(255),
            //     Random().nextInt(255), Random().nextInt(255)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  child: Column(
                    children: [
                      Text(
                        '${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 4)),
                      Text(
                        timeInfo[index].start,
                        style: const TextStyle(fontSize: 10),
                      ),
                      Text(
                        timeInfo[index].end,
                        style: const TextStyle(fontSize: 10),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  child: Column(
                    children: [
                      Text(
                        '${index + 2}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 4)),
                      Text(
                        timeInfo[index + 1].start,
                        style: const TextStyle(fontSize: 10),
                      ),
                      Text(
                        timeInfo[index + 1].end,
                        style: const TextStyle(fontSize: 10),
                      )
                    ],
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

// 绘制一周的所有课程Item
Expanded courseItems(OneWeekModel oneWeekModel, BuildContext context) {
  final viewModel = Get.find<TimeTableViewModel>();
  return Expanded(
    child: MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 左侧课程时间列
            leftTimeBar(),
            // 课表 Tab Item部分
            Expanded(
              child: Obx(() => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(viewModel.weekDay.value.day, (day) {
                    // 用Column绘制一天所有课程Item
                    return Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          // fixme 此物需要精确到，仅当前tian显示底色
                          // color: timeTableController.nowDate.weekday == (i + 1)
                          //     ? Colors.black12
                          //     : Colors.transparent,

                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: oneWeekModel.courseData[day].map((course) {
                            // 根据是否连课返回视图
                            if (course!.name.isEmpty) {
                              return Container(
                                color: Colors.transparent,
                                height: course.showItemLength * containerHeight,
                              );
                            } else {
                              return Container(
                                padding: const EdgeInsets.all(4),
                                height: containerHeight * course.showItemLength,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  width: double.infinity,
                                  height: containerHeight,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: HexColor(course.color, alpha: 15),
                                    border: Border.all(
                                      color: HexColor(course.color),
                                      width: 1,
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
                                      const Padding(
                                          padding: EdgeInsets.only(top: 4)),
                                      Text(
                                        '@${course.teacher}',
                                        style: TextStyle(
                                            color: HexColor(course.color)),
                                      ),
                                      // const Padding(
                                      //     padding: EdgeInsets.only(bottom: 2)),
                                      Text(
                                        course.address,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: HexColor(course.color)),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          }).toList(),
                        ),
                      ),
                    );
                  }))),
            ),
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
          weekTimeNav(oneWeekModel, pageIndex),
          // 课程 Item 方块绘制
          courseItems(oneWeekModel, context),
        ],
      ),
    );
  }
}
