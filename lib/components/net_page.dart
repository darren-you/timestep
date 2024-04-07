import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../enumm/net_page_state_enum.dart';

class NetPage extends StatelessWidget {
  final Rx<NetPageStateEnum> pageStateEnum; // 页面状态枚举
  final RxString errorInfo; // 错误信息
  final Widget successfulBody;

  const NetPage({
    super.key,
    required this.pageStateEnum,
    required this.errorInfo,
    required this.successfulBody,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        Widget bodyWidget = const SizedBox();

        if (pageStateEnum.value == NetPageStateEnum.pageSuccess) {
          debugPrint("值改变 返回成功 NetPageStateEnum.pageSuccess 重构界面");
          bodyWidget = successfulBody;
        } else if (pageStateEnum.value == NetPageStateEnum.pageError) {
          // fixme 此处Widget不能居中，因为不能确定此视图处于ListView中还是Column中
          // 在Column中可以使用 Expanded居中，ListView不能使用
          bodyWidget = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/netebg.png',
                width: 200,
                height: 200,
              ),
              const Text(
                "出错啦!",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 12)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(errorInfo.value),
              ),
            ],
          );
        }

        return bodyWidget;
      },
    );
  }
}
