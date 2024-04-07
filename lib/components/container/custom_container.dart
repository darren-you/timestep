import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomContainer extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget? child;
  final Duration duration;
  final Color? startColor;
  final Color? endColor;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final bool scale;
  final double scaleValue;
  final Clip clipBehavior;
  final bool bgAnim; // 是否开启显示背景色动画
  final bool foreAnim; // 是否开启显示前景色动画

  const CustomContainer({
    Key? key,
    this.onTap,
    this.child,
    this.duration = const Duration(milliseconds: 50),
    this.startColor,
    this.endColor,
    this.color = Colors.white,
    this.margin,
    this.padding,
    this.borderRadius,
    this.scale = true,
    this.scaleValue = 0.98,
    this.clipBehavior = Clip.none,
    this.bgAnim = false,
    this.foreAnim = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /**
     * note: global
     * 
     * GetBuilder 创建时，会去栈根据当前 Widget.tag 中查找绑定传入的 T 泛型controller
     * global 属性可以控制标记是否为全局状态默认为true，init 会默认只在全局初始化一次
     * 如果global为默认，那么其他相同的Widget会共享注入的controller实例
     * 此写法会比直接使用StatefulWidget性能更高，GetBuilder是局部刷新
     */

    // debugPrint("CustomPressContainer 被创建 > > >");
    return GetBuilder<CustomPressContainerController>(
      global: false,
      init: CustomPressContainerController(
        color: color,
        duration: duration,
        endColor: endColor,
        onTap: onTap,
        scaleValue: scaleValue,
        startColor: startColor,
      ),
      builder: (controller) {
        // debugPrint("局部刷新 > > > 1");
        return GestureDetector(
          onTapDown: controller._handleTapDown,
          onTapUp: controller._handleTapUp,
          onTapCancel: controller._handleTapCancel,
          behavior: HitTestBehavior.translucent, // 允许点击事件穿透
          child: AnimatedBuilder(
            animation: controller.animController,
            builder: (context, child) {
              // debugPrint("局部刷新 > > > 2");
              return Transform.scale(
                scale: scale ? controller.scaleAnimation.value : 1.0,
                child: Container(
                  margin: margin,
                  padding: padding,
                  clipBehavior: clipBehavior,
                  decoration: BoxDecoration(
                    color: bgAnim ? controller.bgColorAnimation.value : color,
                    borderRadius: borderRadius,
                  ),
                  foregroundDecoration: BoxDecoration(
                    color:
                        foreAnim ? controller.foreColorAnimation.value : color,
                    borderRadius: borderRadius,
                  ),
                  child: child,
                ),
              );
            },
            child: child,
          ),
        );
      },
    );
  }
}

class CustomPressContainerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // 构造参数
  late final Duration duration;
  late final Color? startColor;
  late final Color? endColor;
  late final Color? color;
  late final double scaleValue;
  late final VoidCallback? onTap;

  CustomPressContainerController({
    required this.duration,
    required this.startColor,
    required this.endColor,
    required this.color,
    required this.scaleValue,
    required this.onTap,
  });

  // 内部使用
  late final AnimationController animController;
  late final Animation<double> scaleAnimation;
  late final Animation<Color?> bgColorAnimation;
  late final Animation<Color?> foreColorAnimation;
  var isPressed = false;

  @override
  void onInit() {
    super.onInit();

    animController = AnimationController(vsync: this, duration: duration);

    scaleAnimation = Tween<double>(begin: 1.0, end: scaleValue).animate(
      CurvedAnimation(parent: animController, curve: Curves.decelerate),
    );

    bgColorAnimation = ColorTween(
      begin: color == null
          ? startColor?.withOpacity(1.0)
          : color?.withOpacity(1.0),
      end: color == null ? endColor?.withOpacity(0.8) : color?.withOpacity(0.8),
    ).animate(
      CurvedAnimation(parent: animController, curve: Curves.decelerate),
    );

    foreColorAnimation = ColorTween(
      begin: Colors.grey.withOpacity(0.0),
      end: Colors.grey.withOpacity(0.3),
    ).animate(
      CurvedAnimation(parent: animController, curve: Curves.decelerate),
    );
  }

  // 按下时的逻辑
  void _handleTapDown(TapDownDetails details) {
    isPressed = true;
    animController.forward();
  }

  // 抬起时的逻辑
  Future<void> _handleTapUp(TapUpDetails details) async {
    if (isPressed) {
      await animController.animateTo(1.0).whenComplete(() {
        animController.reverse().whenComplete(() {
          if (!Get.context!.mounted) return;
          isPressed = false;
        });
      });
    } else {
      await animController.reverse();
    }

    // 回调点击事件
    onTap?.call();
  }

  // 取消按下操作的逻辑
  void _handleTapCancel() {
    isPressed = false;
    animController.reverse();
  }

  @override
  void onClose() {
    animController.dispose(); // 手动释放动画控制器
    super.onClose();
  }
}

/**
   * 将GetBuilder改为GetX的区别如下：

    语法简洁：GetX使用了更简洁的语法，不需要显式地创建GetBuilder。只需要在需要使用状态的地方调用GetX<ControllerType>()即可。

    自动释放资源：GetX会自动释放Controller实例，无需手动调用dispose()方法进行资源释放。当页面被销毁时，GetX会自动处理Controller的生命周期。

    延迟加载：GetX使用懒加载的方式创建Controller实例，只有在需要使用该Controller的时候才会进行初始化。这可以提高性能，避免不必要的资源消耗。

    更多功能：GetX提供了更多的功能和便利方法，例如GetX.to、GetX.put、GetX.find等，可以更灵活地管理状态和控制页面跳转。

    ！ ！ ！ 使用GetX、Obs中需要传入.obs可观察变量
   * 
   * 
   * 
   * 使用GetX和GetBuilder的选择取决于项目的需求和个人的偏好。以下是一些使用场景示例：
    使用GetX的情况：

    需要更简洁的语法和更多的便利方法。
    需要自动释放资源，不需要手动管理Controller的生命周期。
    希望延迟加载Controller实例，以提高性能。
    需要使用GetX的其他功能，如路由管理、国际化等。

    使用GetBuilder的情况：

    不需要额外的便利方法和功能，只需简单地构建UI。
    更喜欢显示地创建和管理状态。
    对性能要求不高，不需要自动释放资源或延迟加载。
   * 
   * 
   */
