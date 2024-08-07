import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:timestep/services/app_init_service.dart';

import '../../../enumm/course_enum.dart';
import '../../../utils/date_util.dart';
import '../../../utils/my_screen_util.dart';
import '../model/course_model.dart';
import '../my_course/model/course_info.dart';
import '../repository/course_data_service.dart';

class TimeTableViewModel extends GetxController {
  static const int oneWeekDay = 7;
  static const int oneDayCourse = 12;
  // 依赖
  final courseRepo = Get.find<CourseDataService>();
  // 界面相关
  final pageController = PageController(initialPage: 0); // 默认选中第一页

  final dateNowText = formatDate(DateTime.now(), [m, '月', d, '日']); // 标题时间
  int nowWeek = 0; // 当前时间属于第几周
  final courseWeekListController = ScrollController();
  bool tapCourseItem = true;
  late int tapCourseIndex = nowWeek;

  SelectCourseEnum selectCourse = SelectCourseEnum.first; // 当前选中第几个课程
  // 状态
  var currentWeekIndex = 1.obs; // 标题周，默认为【第 1 周】
  var weekDay = OneWeekDayEnum.week5.obs; // 一周显示多少天，默认5天，需要本地存储
  var changeCourseSate = ChangeCourseEnum.off.obs; // 是否开启课程快捷切换
  var courseModel = CourseModel.empty().obs;
  var isExpanded = false.obs;

  // 时间线相关
  var nowTime = DateFormat('HH:mm').format(DateTime.now()).obs;
  var timeLinePosition = 0.0.obs;
  ScrollController courseScrollerController = ScrollController();
  late Timer _timer;

  /// 初始化课表数据
  CourseModel initCourseModel(
      List<List<List<CourseInfo>>> courseData,
      String name,
      DateTime termStartTime,
      CourseItemColorEnum courseItemColor) {
    /*
        计算用户设置的起始时间，所在周对应日期，所在周，周一的日期
        正确的周一日期 = 设置日期 - （设置日期对应周几（int） - 1）
      */
    final realyTermStartTime =
        termStartTime.subtract(Duration(days: termStartTime.weekday - 1));
    final maxWeek = _getMaxWeek(courseData); //计算最大结束周
    final courseColorMap = _setItemColor(courseData, courseItemColor);
    final courseAllPages =
        _allCourseWeek(maxWeek, realyTermStartTime, courseData, courseColorMap);

    final courseModel = CourseModel(
        courseData: courseData,
        courseAllPages: courseAllPages,
        name: name,
        termStartTime: termStartTime,
        realyTermStartTime: realyTermStartTime,
        maxWeek: maxWeek,
        courseColor: courseItemColor,
        courseColorMap: courseColorMap);

    return courseModel;
  }

  /// 计算学期课程截止周
  int _getMaxWeek(List<List<List<CourseInfo?>>> data) {
    var maxWeek = 0;
    // 遍历所有课程计算最大周
    for (var i = 0; i < oneWeekDay; i++) {
      for (var j = 0; j < oneDayCourse; j++) {
        if (data[i][j].isNotEmpty) {
          for (var oneCourse in data[i][j]) {
            if (maxWeek < oneCourse!.weekEnd) {
              maxWeek = oneCourse.weekEnd;
            }
          }
        }
      }
    }

    return maxWeek;
  }

  /// 设置课程Item颜色
  Map<String, String> _setItemColor(List<List<List<CourseInfo?>>> courseData,
      CourseItemColorEnum courseColor) {
    Map<String, String> colorMap = {};

    // 遍历所有课程
    for (var i = 0; i < oneWeekDay; i++) {
      for (var j = 0; j < oneDayCourse; j++) {
        if (courseData[i][j].isNotEmpty) {
          // 设置颜色
          for (var oneCourse in courseData[i][j]) {
            if (!colorMap.containsKey(oneCourse?.name)) {
              colorMap[oneCourse!.name] =
                  courseColor.itemColor[colorMap.length];
            }
          }
        }
      }
    }

    return colorMap;
  }

  /// 计算所有周的课程数据
  List<OneWeekModel> _allCourseWeek(
      int maxWeek,
      DateTime realyTermStartTime,
      List<List<List<CourseInfo?>>> courseData,
      Map<String, String> courseColorMap) {
    debugPrint("计算所有周课程数据... 课程截止周:$maxWeek");
    final allWeekModelList = <OneWeekModel>[];
    for (var i = 0; i < maxWeek; i++) {
      List<List<CourseInfo>> oneWeekCourseData = List.generate(
          oneWeekDay,
          (_) => List.generate(oneDayCourse,
              (_) => CourseInfo.empty())); // 7天，每天12节课，初始填充为一个空的CourseInfo对象

      // 计算周时间
      // 单周 月: 2 日期:[27, 28, 1, 2, 3, 4, 5]
      late int month;
      List<int> weekTimes = [];
      for (var j = 0; j < oneWeekDay; j++) {
        var span = Duration(days: i * oneWeekDay + j);
        DateTime weekDateTimeInfo = realyTermStartTime.add(span);
        // 取周一的日期对应月，设置成标题 Month
        if (j == 0) {
          month = weekDateTimeInfo.month;
        }
        weekTimes.add(weekDateTimeInfo.day);
      }

      for (var week = 0; week < oneWeekDay; week++) {
        for (var time = 0; time < oneDayCourse; time++) {
          // 可能有多节课
          for (var item = 0; item < courseData[week][time].length; item++) {
            CourseInfo? originCourseInfo = courseData[week][time][item];

            if (originCourseInfo != null) {
              if (originCourseInfo.weekStart <= i + 1 &&
                  i + 1 <= originCourseInfo.weekEnd) {
                // 设置课程信息
                debugPrint('设置课程信息 ${originCourseInfo.name}');
                oneWeekCourseData[week][time] = originCourseInfo;
                // 给课程设置颜色
                oneWeekCourseData[week][time].color =
                    courseColorMap[originCourseInfo.name]!;
                // 设置显示长度 [1-4节]
                oneWeekCourseData[week][time].showItemLength =
                    (originCourseInfo.timeEnd - originCourseInfo.timeStart + 1);
                // 设置被挤压的节长度为0
                for (var i = originCourseInfo.timeStart;
                    i < originCourseInfo.timeEnd;
                    i++) {
                  oneWeekCourseData[week][i].showItemLength = 0;
                }
              }
            }
          }
        }
      }
      allWeekModelList.add(OneWeekModel(oneWeekCourseData, month, weekTimes));
    }

    return allWeekModelList;
  }

  /// 计算当前时间属于第几周
  int _nowWeek(CourseModel courseModel) {
    //计算当前时间，属于第几周 -> 当前时间 - 开始时间） ～/ 7 + 1
    return DateTime.now().difference(courseModel.realyTermStartTime).inDays ~/
            oneWeekDay +
        1;
  }

  /// 计算当前日期是否显示色块
  bool showColor(int pageIndex, int dayIndex) {
    return (nowWeek == pageIndex + 1 && dayIndex + 1 == DateTime.now().weekday);
  }

  /// 初始化界面显示所需数据
  void initPageState() {
    debugPrint("初始化页面数据 状态");
    // 读取本地课程第 [0] 个课程表
    final allCourseModel = courseRepo.getAllCourseModel();
    if (allCourseModel.courseModelList.isNotEmpty) {
      // 更新状态
      courseModel(allCourseModel.courseModelList[0]);
      nowWeek = _nowWeek(allCourseModel.courseModelList[0]);
      currentWeekIndex.value = nowWeek;
    }
  }

  /// event: 点击当前时间Widget -> 跳转到对应周
  toNowWeekPage({bool animate = true}) {
    if (courseModel.value.courseAllPages.isNotEmpty) {
      if (animate) {
        pageController.animateToPage(
          nowWeek - 1, // PageView中页面索引从0开始
          duration: const Duration(seconds: 2),
          curve: Curves.fastLinearToSlowEaseIn,
        );
        debugPrint("自动滑动到 page ${nowWeek - 1} ");
      } else {
        pageController.jumpToPage(nowWeek - 1);
        debugPrint("自动跳转到 page ${nowWeek - 1}");
      }
    }
  }

  /// 自动滚动周List
  void _autoScrollerWeekList({required bool useAnimation}) {
    final offset = _getOffsetByCurrentWeek();
    if (useAnimation) {
      courseWeekListController.animateTo(offset,
          duration: const Duration(milliseconds: 1800),
          curve: Curves.fastLinearToSlowEaseIn);
    } else {
      courseWeekListController.jumpTo(offset);
    }
  }

  /// event: 滑动page -> 更新state: currentWeek当前周
  changePage(int index) {
    currentWeekIndex.value = index + 1;
    _autoScrollerWeekList(useAnimation: true);
    logger.d("pager滑动前:    -> $tapCourseItem  当前page:   -> $index");
  }

  /// 计算滚动位置offset
  ///
  /// 让选中week显示在中间
  double _getOffsetByCurrentWeek() {
    var offset = 0.0;
    final screenWidth = MyScreenUtil.getInstance().screenWidth;
    final halfScreenWidth = screenWidth / 2;
    final halfScreenItem = (halfScreenWidth / (42.h + 8.w)).ceil();
    // 选中week
    final selectedWeek = currentWeekIndex.value;
    // 选课表共有多少周
    final allWeeks = courseModel.value.courseAllPages.length;
    if (selectedWeek > halfScreenItem &&
        selectedWeek <= (allWeeks - halfScreenItem)) {
      offset = selectedWeek * (42.h + 8.w) - (42.h / 2) - halfScreenWidth;
    } else if (selectedWeek <= halfScreenItem) {
      offset = 0;
    } else {
      offset = allWeeks * (42.h + 8.w) + 8.w - screenWidth;
    }

    return offset;
  }

  /// event: 点击周预览Item -> 更改当前选中周Index，滑动到对应Page
  tapCourseWeek(int tapIndex) {
    tapCourseIndex = tapIndex;
    tapCourseItem = false;

    debugPrint("点击 courseWeek -> tapCourseItem $tapCourseItem");

    pageController.jumpToPage(tapIndex);
  }

  /// events: 导入课程事件 -> 网络请求获取课表数据 / 更新state: courseModel / 本地存储课程数据 / 计算当前时间属于第几周
  void importCourseData(
    List<List<List<CourseInfo>>> newCourseData,
    String name,
    DateTime termStartTime,
    CourseItemColorEnum courseItemColor,
  ) {
    // 初始化新的 CourseModel 数据
    final saveCourseModel =
        initCourseModel(newCourseData, name, termStartTime, courseItemColor);

    courseRepo.addCourseModel(saveCourseModel);

    // 更新状态 [只有当本地课程数据为 1 的时候才更新]
    if (courseRepo.getAllCourseModel().courseModelList.length == 1) {
      initPageState();
      //toNowWeekPage();
    }
  }

  // events: 编辑课表事件 -> 更改学期起始时间 / 更改课程颜色
  // void seetingCourseModel(int index, CourseModel newCourseModel) {
  //   // 初始化修改后的 CourseModel 数据
  //   final saveCourseModel = initCourseModel(
  //       newCourseModel.courseData,
  //       newCourseModel.name,
  //       newCourseModel.termStartTime,
  //       newCourseModel.courseColor);
  //   // 更新单个本地 CourseModel 数据
  //   courseRepo.updateCourseModel(index, saveCourseModel);
  // }

  /// events: 点击切换课表 -> 显示本地第1/2课表切换
  void changeCourse({required bool animate}) {
    debugPrint("点击快捷切换课表");
    final allCourseModel = courseRepo.getAllCourseModel();
    if (allCourseModel.courseModelList.length > 1) {
      // 更新状态
      courseModel(allCourseModel
          .courseModelList[selectCourse == SelectCourseEnum.first ? 1 : 0]);
      nowWeek = _nowWeek(allCourseModel
          .courseModelList[selectCourse == SelectCourseEnum.first ? 1 : 0]);

      selectCourse = selectCourse == SelectCourseEnum.first
          ? SelectCourseEnum.second
          : SelectCourseEnum.first;

      toNowWeekPage(animate: animate);
    }
  }

  /// events: 点击展开周预览
  void openMoreInfo() {
    // 展开前滚动到最佳位置
    if (!isExpanded.value) {
      _autoScrollerWeekList(useAnimation: false);
    }
    if (courseModel.value.courseAllPages.isNotEmpty) {
      isExpanded.value = !isExpanded.value;
    }

    // courseWeekListController.animateTo((currentWeekIndex.value - 1) * 58,
    //     duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }

  /// events: 界面启动 -> 读取本地课程数据 / 更新state: courseModel / 一周显示多少天
  void _initLocalCourseData() {
    initPageState();
    weekDay.value = courseRepo.getShowWeekend();
    changeCourseSate.value = courseRepo.getChangeCourse();
  }

  /// 更新当前时间对应的位置、时间
  void getNowTimePosition() {
    nowTime.value = DateFormat('HH:mm').format(DateTime.now());
    final timeInfo = courseModel.value.courseTime;

    for (var i = 0; i < timeInfo.length; i++) {
      final startStr = timeInfo[i].start.split(':');
      final endStr = timeInfo[i].end.split(':');

      final startTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        int.parse(startStr[0]),
        int.parse(startStr[1]),
      );

      final endTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        int.parse(endStr[0]),
        int.parse(endStr[1]),
      );

      debugPrint(
          "startTime:${startTime.toString()}, endTime:${endTime.toString()}");

      // 在某节课时间内
      if (startTime.isBefore(DateTime.now()) &&
          endTime.isAfter(DateTime.now())) {
        timeLinePosition.value =
            (DateUtil.getMinuteDiff(DateTime.now(), startTime) * (80.h / 45) +
                5.h +
                100.h * i);
        debugPrint("在课内: ${timeLinePosition.value.toString()}");
        break;
      }
      // 下课时间段
      if ((i + 1) < timeInfo.length) {
        final nextStartStr = timeInfo[i + 1].start.split(':');
        final nextstartTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          int.parse(nextStartStr[0]),
          int.parse(nextStartStr[1]),
        );

        if (endTime.isBefore(DateTime.now()) &&
            nextstartTime.isAfter(DateTime.now())) {
          timeLinePosition.value = 100.h * i + 95.h;
          debugPrint("在课间: ${timeLinePosition.value.toString()}");
          break;
        }
      }
    }
  }

  @override
  void onInit() {
    super.onInit();

    // 界面启动时，加载本地课程数据
    _initLocalCourseData();
  }

  @override
  void onReady() {
    super.onReady();

    // 自动滑动到当前周Page
    toNowWeekPage(animate: false);
    // 每分钟更新当前时间位置
    getNowTimePosition();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint("这里的代码会在UI更新后执行");
      courseScrollerController.jumpTo(timeLinePosition.value);
    });
    _timer = Timer.periodic(const Duration(milliseconds: 10), (Timer t) {
      getNowTimePosition();
    });
  }
}
