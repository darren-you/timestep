import 'package:get/get.dart';
import 'package:timestep/business/todo/todo_page_vm.dart';

import '../business/app/about_app/about_wejinda_page.dart';
import '../business/app/about_app/about_wejinda_page_vm.dart';
import '../business/app/check_update/app_update_page.dart';
import '../business/app/check_update/app_update_page_vm.dart';
import '../business/home_nav/bnp_vm.dart';
import '../business/home_nav/bottom_nav_page.dart';

import '../business/service_environment/base_url_page.dart';
import '../business/service_environment/base_url_page_vm.dart';
import '../business/time_table/course_info/course_info_page.dart';
import '../business/time_table/course_info/course_info_page_vm.dart';
import '../business/time_table/course_setting/seeting_page_vm.dart';
import '../business/time_table/course_setting/setting_page.dart';
import '../business/time_table/course_table/timetable_vm.dart';
import '../business/time_table/my_course/my_course_page.dart';
import '../business/time_table/my_course/my_course_page_vm.dart';
import '../business/time_table/repository/course_data_impl.dart';
import '../business/time_table/repository/course_data_service.dart';
import '../business/user/account_center/user_page_vm.dart';
import '../business/user/repository/account_data_impl.dart';
import '../business/user/repository/account_data_service.dart';
import '../business/web_view/web_doc_page.dart';
import '../business/web_view/web_doc_page_vm.dart';
import '../utils/page_path_util.dart';
import 'app_rountes_middleware.dart';

class AppRountes {
  // 别名路由配置
  static List<GetPage<dynamic>>? appRoutes = [
    // APP进入主页，导航栏界面
    GetPage(
      name: PagePathUtil.bottomNavPage,
      page: () => const BottomNavPage(),
      middlewares: [UserLoginMw()],
      binding: BindingsBuilder(
        () {
          Get.lazyPut(() => BottomNavViewModel());
          Get.lazyPut(() => TimeTableViewModel());
          Get.lazyPut<CourseDataService>(() => CourseDataImpl());
          Get.lazyPut<AccountDataService>(() => AccountDataImpl());
          Get.lazyPut(() => TodoPageViewModel());
          Get.lazyPut(() => UserPageViewModel());
        },
      ),
    ),
    // 课表设置页面
    GetPage(
      name: PagePathUtil.timeTableSettingPage,
      page: () => const TimeTableSettingPage(),
      binding: BindingsBuilder(
        () {
          Get.lazyPut(() => TimeTableSeetingPageViewModel());
        },
      ),
    ),
    // 我的课表界面
    GetPage(
      name: PagePathUtil.timeTableMyCoursePage,
      page: () => const MyCoursePage(),
      binding: BindingsBuilder(
        () {
          Get.lazyPut(() => MyCoursePageViewModel());
        },
      ),
    ),
    // 课表信息界面
    GetPage(
      name: PagePathUtil.courseUpdatePage,
      page: () => const CourseInfoPage(),
      binding: BindingsBuilder(
        () {
          Get.lazyPut(() => CourseInfoPageViewModel());
        },
      ),
    ),
    // 关于We锦大界面
    GetPage(
        name: PagePathUtil.aboutWejindaPage,
        page: () => const AboutWejindaPage(),
        binding: BindingsBuilder(
          () {
            Get.lazyPut(() => AboutWejindaPageViewModel());
          },
        )),
    // app升级信息界面
    GetPage(
        name: PagePathUtil.appUpdatePage,
        page: () => const AppUpdatePage(),
        binding: BindingsBuilder(
          () {
            Get.lazyPut(() => AppUpdatePageViewModel());
          },
        )),
    // WebView Doc页面
    GetPage(
        name: PagePathUtil.webDocPage,
        page: () => const WebDocPage(),
        binding: BindingsBuilder(
          () {
            Get.lazyPut(() => WebDocPageViewModel());
          },
        )),
    // 修改BaseUrl界面
    GetPage(
        name: PagePathUtil.editBaseUrlPage,
        page: () => const BaseUrlPage(),
        binding: BindingsBuilder((() {
          Get.lazyPut<BaseUrlPageViewModel>(() => BaseUrlPageViewModel());
        }))),
  ];
}
