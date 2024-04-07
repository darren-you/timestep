// 标题
enum WeekTextEnum {
  startM(['一', '二', '三', '四', '五', '六', '日']), // 从周一开始
  startS(['日', '一', '二', '三', '四', '五', '六']);

  final List<String> text;

  const WeekTextEnum(this.text);
}

// 一周显示多少天的课程
enum OneWeekDayEnum {
  week5(5),
  week7(7);

  final int day;

  const OneWeekDayEnum(this.day);
}

// 一周显示多少天的课程
enum ChangeCourseEnum {
  off(0),
  on(1);

  final int state;

  const ChangeCourseEnum(this.state);
}

// 一周显示多少天的课程
enum SelectCourseEnum {
  first(0),
  second(1);

  final int selectIndex;

  const SelectCourseEnum(this.selectIndex);
}

// 课程Item的背景颜色
enum CourseItemColorEnum {
  color_1([
    "#3e62ad",
    "#f39800",
    "#f09199",
    "#a2d7dd",
    "#2ca9e1",
    "#b8d200",
    "#2ca9e1",
    "#674196",
    "#65318e",
    "#f7c114",
    "#a2d7dd",
    "#b8d200",
    "#674196",
  ]),
  color_2([
    "#674196",
    "#b8d200",
    "#a2d7dd",
    "#f7c114",
    "#65318e",
    "#674196",
    "#2ca9e1",
    "#b8d200",
    "#2ca9e1",
  ]);

  final List<String> itemColor;

  const CourseItemColorEnum(this.itemColor);
}
