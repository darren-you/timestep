import '../../../enumm/course_enum.dart';
import '../model/course_model.dart';

abstract class CourseDataService {
  // 存储或者更新本地所有课程数据
  void saveAllCourseModel(AllCourseModel newAllCourseModel);

  // 读取本地所有课程信息数据
  AllCourseModel getAllCourseModel();

  // 添加新的课程数据
  void addCourseModel(CourseModel newCourseModel);

  // 删除课程数据
  void delCourseModel(int delIndex);

  // 修改某个课程信息
  void updateCourseModel(int index, CourseModel newCourseModel);

  // 存储一周显示多少天课程
  void saveShowWeekend(OneWeekDayEnum oneWeekDayEnum);

  // 获取一周显示多少天课程
  OneWeekDayEnum getShowWeekend();

  // 存储是否开启快捷切换课表
  void saveChangeCourse(ChangeCourseEnum changeCourseEnum);

  // 获取是否开启快捷切换课表
  ChangeCourseEnum getChangeCourse();
}
