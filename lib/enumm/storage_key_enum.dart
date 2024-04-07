/*
  @descripton 定义本地存储的 键
 */
enum CourseStorageKeyEnum {
  courseData("courseData"),
  showWeekDay("showWeekDay"),
  changeCourse("changeCourse"),
  selectCourse("selectCourse");

  final String key;

  const CourseStorageKeyEnum(this.key);
}

// 用户登录属性名，枚举定义
enum AccountStorageKeyEnum {
  appUser(username: "appUserName", password: "appUserPassword"),
  jww(username: "JwwUserName", password: "JwwPassword"),
  ;

  final String username;
  final String password;

  const AccountStorageKeyEnum({
    required this.username,
    required this.password,
  });
}
