import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

class DateUtil {
  DateUtil._();

  // 计算两个年份之间的所有年份值
  static List<int> getBetweenYear(
      {required int startYear, required int endYear}) {
    List<int> years = [];
    for (int year = startYear; year <= endYear; year++) {
      years.add(year);
    }
    return years;
  }

  // 返回所有月份
  static List<int> getAllMonthList() {
    return const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  }

  /// 计算某年某月，所有日值
  static List<int> getYMdays({required int year, required int month}) {
    List<int> days = [];

    int daysInMonth = DateTime.utc(year, month + 1, 0, 0, 0).day;

    for (int i = 1; i <= daysInMonth; i++) {
      DateTime date = DateTime.utc(year, month, i, 0, 0, 0).toLocal();

      days.add(date.day);
    }

    return days;
  }

  /// 根据DateTime返回当前月对应的day的DateTime列表
  static List<DateTime> getDaysInMonth(DateTime dateTime) {
    final year = dateTime.year;
    final month = dateTime.month;
    final lastDayOfMonth = DateTime(year, month + 1).day;

    List<DateTime> days = [];
    for (int i = 1; i <= lastDayOfMonth; i++) {
      // 创建一个表示午夜的DateTime对象
      final dayDateTime = DateTime.utc(year, month, i);
      days.add(dayDateTime.toLocal());
    }

    return days;
  }

  /// 根据DateTime返回AM或者PM
  static String getAmOrPm(DateTime dateTime) {
    return dateTime.hour < 12 ? "AM" : "PM";
  }

  /// 根据DateTime返回02:28 PM格式时间
  static String getAmOrPmFromatTime(DateTime dateTime) {
    final timeEnd = getAmOrPm(dateTime);
    return formatDate(dateTime, [h, ':', m, ' ', timeEnd]);
  }

  /// 生成随机DateTime
  static DateTime getRandomDateTime() {
    final now = DateTime.now();
    final random = Random();
    final year = now.year - random.nextInt(10);
    final month = now.month - random.nextInt(3);
    final day = now.day - random.nextInt(7);
    final hour = now.hour - random.nextInt(12);
    final minute = now.minute - random.nextInt(60);
    return DateTime(year, month, day, hour, minute);
  }

  /// 根据DateTime返回例如：'6月27日' 此格式的字符串
  static String getMonthDayText(DateTime dateTime) {
    return DateFormat('M月d日').format(dateTime);
  }

  /// 计算DateTime1收否在DateTime2之前
  static bool isBefore(DateTime dateTime1, DateTime dateTime2) {
    return dateTime1.isBefore(dateTime2);
  }
}
