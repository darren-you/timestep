import 'package:flutter/widgets.dart';

import '../../time_table/my_course/model/course_info.dart';

class SchoolCardItemVO {
  late Icon icon;
  late Widget? title;
  late Widget? info;
  late Widget? body;
  late Function()? onTap;

  SchoolCardItemVO(this.icon, this.title, this.info, this.body, this.onTap);
}

class SchoolCardData {
  late String info;
  late String updateTime;
  late String startTime;
  late String endTime;
  CourseInfo? data;

  SchoolCardData(
      {required this.info,
      required this.updateTime,
      required this.startTime,
      required this.endTime,
      this.data});

  SchoolCardData.empty({
    this.info = "暂无课程",
  });
}
