import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../enumm/color_enum.dart';

class AnimatedToast extends StatefulWidget {
  final BuildContext context;
  OverlayEntry? overlayEntry;
  final String? msg;

  AnimatedToast(
      {super.key,
      required this.context,
      required this.overlayEntry,
      required this.msg});

  @override
  AnimatedToastState createState() => AnimatedToastState();
}

class AnimatedToastState extends State<AnimatedToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // 进出场动画时间
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
      reverseCurve: Curves.linear,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // 停留时间
          Future.delayed(const Duration(milliseconds: 2000)).then((_) {
            if (mounted) {
              // 检查widget是否还在，View Tree中
              _controller.reverse();
            }
          });
        } else if (status == AnimationStatus.dismissed) {
          Future.delayed(_controller.duration ?? Duration.zero).then((_) {
            widget.overlayEntry?.remove();
          });
        }
      });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          bottom: context.mediaQueryPadding.bottom + 64,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: _animation.value,
              child: Container(
                height: 40,
                width: 100,
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: MyColors.notifationBackground.color,
                      offset: const Offset(0.0, 4.0), // 偏移
                      blurRadius: 12.0, // 模糊程度
                      spreadRadius: 2.0, // 扩散程度
                    ),
                  ],
                ),
                child: Text(
                  widget.msg!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }
}
