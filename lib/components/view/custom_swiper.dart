import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../enumm/color_enum.dart';
import '../../utils/my_timer.dart';
import '../keep_alive_wrapper.dart';

class CustomSwiper extends StatelessWidget {
  final List<String> imgUrlList;

  const CustomSwiper({super.key, required this.imgUrlList});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      global: false,
      init: CustomSwiperController(
        imgUrlList: imgUrlList,
      ),
      builder: (controller) {
        return Stack(
          children: [
            PageView.builder(
              controller: controller.pageController,
              itemBuilder: (context, index) {
                final actualIndex = index % imgUrlList.length;
                return Listener(
                  onPointerDown: (details) {
                    controller.myTimer.pause();
                  },
                  onPointerUp: (details) {
                    controller.myTimer.start();
                  },
                  child: KeepAliveWrapper(
                    child: AnimatedBuilder(
                      animation: controller.pageController,
                      builder: (context, child) {
                        // 获取当前页面的索引
                        double pageOffset = 0.0;
                        if (controller.pageController.hasClients &&
                            controller.pageController.position.haveDimensions) {
                          pageOffset = controller.pageController.page! - index;
                        }

                        // 计算缩放因子
                        double scaleFactor =
                            (1 - (pageOffset.abs() * 0.2)).clamp(0.8, 1.0);

                        // 计算透明度
                        double fadeFactor =
                            (1 - (pageOffset.abs() * 0.5)).clamp(0.5, 1.0);

                        // 计算水平平移值，以减少页面间隔
                        // 这里我们使用页面宽度的一部分来计算平移值，确保它足够大
                        double viewportWidth = context.width;
                        double horizontalOffset =
                            pageOffset * viewportWidth / 7;

                        // 应用变换效果
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..scale(scaleFactor)
                            ..translate(horizontalOffset, 0, 0),
                          child: Opacity(
                            opacity: fadeFactor,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        height: 160,
                        width: context.width,
                        clipBehavior: Clip.hardEdge,
                        margin: const EdgeInsets.only(left: 12, right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExtendedImage.network(
                          //"https://darrenyou.cn/wejinda/res/img/swapper/swapper_${actualIndex + 1}.jpg",
                          imgUrlList[actualIndex],
                          fit: BoxFit.cover,
                          cache: true,
                          //cancelToken: cancellationToken,
                        ),
                      ),
                    ),
                  ),
                );
              },
              onPageChanged: (value) {
                controller.swipChange(value);
              },
            ),

            // 指视标
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  imgUrlList.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Obx(() => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 6,
                            width: 6,
                            decoration: BoxDecoration(
                              color: controller.swiperCurrentIndex.value ==
                                      index
                                  ? Colors.white
                                  : MyColors.iconGrey2.color.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CustomSwiperController extends GetxController {
  final List<String> imgUrlList;

  late final PageController pageController;
  late final MyTimer myTimer;
  var swiperCurrentIndex = 0.obs;

  CustomSwiperController({required this.imgUrlList});

  void swipChange(int currentIndex) {
    swiperCurrentIndex.value = currentIndex % imgUrlList.length;
  }

  @override
  void onInit() {
    super.onInit();

    pageController = PageController(
      viewportFraction: 1,
      // 初始化选中index
      initialPage: 100 * (imgUrlList.length),
    );

    myTimer = MyTimer(
      duration: const Duration(seconds: 5),
      function: () {
        pageController.nextPage(
            duration: const Duration(milliseconds: 1500), curve: Curves.ease);
      },
    );

    myTimer.start();
  }

  @override
  void onReady() {
    super.onReady();

    pageController.addListener(() {});
  }
}
