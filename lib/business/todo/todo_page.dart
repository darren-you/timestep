import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:timestep/components/container/custom_container.dart';
import 'package:timestep/components/notification/custom_notification.dart';

import '../../components/container/custom_icon_button.dart';
import '../../enumm/color_enum.dart';
import '../../enumm/nav_enum.dart';
import '../../utils/assert_util.dart';
import 'todo_page_vm.dart';

class TodoPage extends GetView<TodoPageViewModel> {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background.color,
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Column(
          children: [
            // 自定义导航栏
            Container(
              padding: EdgeInsets.only(
                  top: context
                      .mediaQueryPadding.top), // 设置顶部 AppBar 的顶部内边距为状态栏的高
              color: Colors.white,
              child: Column(
                children: [
                  //日期、第几周、菜单按钮
                  SizedBox(
                    height: 50,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // 课表名称
                        Positioned(
                          left: 32,
                          child: CustomContainer(
                            borderRadius: BorderRadius.circular(25),
                            scaleValue: 0.9,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              width: 34,
                              height: 34,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                //color: MyColors.background.color,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Transform.rotate(
                                angle: -600.0,
                                child: SvgPicture.asset(AssertUtil.iconGo),
                              ),
                            ),
                          ),
                        ),

                        // 标题周信息
                        Align(
                          alignment: Alignment.center,
                          child: // 居中标题第几周
                              GestureDetector(
                            onTap: () {
                              // 展开周预览图菜单
                            },
                            onDoubleTap: () {},
                            child: Container(
                              //color: Colors.amber,
                              width: 100,
                              height: 50,
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text("2024年4月7日")],
                              ),
                            ),
                          ),
                        ),

                        // 菜单按钮
                        Positioned(
                          right: 32,
                          child: CustomContainer(
                            borderRadius: BorderRadius.circular(25),
                            scaleValue: 0.9,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              width: 34,
                              height: 34,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                //color: MyColors.background.color,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: SvgPicture.asset(AssertUtil.iconGo),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ), // 周标题栏
                ],
              ),
            ),

            // 课表内容
            Expanded(
              child: PageView.builder(
                itemCount: 5,
                //controller: controller.pageController,
                onPageChanged: (pageIndex) {},
                itemBuilder: (context, index) {
                  return Center(
                    child: Text("第 $index 页"),
                  );
                },
              ),
            ),

            // 底部导航行高度
            Padding(
                padding:
                    EdgeInsets.only(bottom: NavigationOptions.hight55.height)),
          ],
        ),
      ),
    );
  }
}
