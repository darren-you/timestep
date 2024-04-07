import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/appbar/normal_appbar.dart';
import '../../../components/container/custom_container.dart';
import '../../../components/view/custom_body.dart';
import '../../../enumm/appbar_enum.dart';
import '../../../enumm/color_enum.dart';
import '../../../utils/app_info_util.dart';
import 'app_update_page_vm.dart';

class AppUpdatePage extends GetView<AppUpdatePageViewModel> {
  const AppUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background.color,
      body: CustomBody(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          appBar: const NormalAppBar(
              title: Text(
            "更新日志",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )),
          body: Column(
            children: [
              SizedBox(
                height: context.height -
                    AppBarOptions.hight50.height -
                    context.mediaQuery.padding.top,
                //color: Colors.amber,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Image.network(
                              "https://singlestep.cn/wejinda/res/img/swapper_2.png",
                              width: 100,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 16)),
                          const Text("We锦大",
                              style: TextStyle(
                                  letterSpacing: 2,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          const Padding(padding: EdgeInsets.only(top: 4)),
                          Text(
                            "version: ${AppInfoUtil.appVersion}",
                            style: const TextStyle(color: Colors.black54),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            Obx(() => Text(controller.updateDesc.value)),
                          ],
                        )),
                    Expanded(
                      flex: 1,
                      child: Platform.isAndroid
                          ? Container(
                              alignment: Alignment.bottomCenter,
                              padding: const EdgeInsets.all(32),
                              //color: Colors.pink,
                              child: CustomContainer(
                                borderRadius: BorderRadius.circular(30),
                                duration: const Duration(milliseconds: 180),
                                onTap: controller.downloadApk,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Text(
                                    "去下载",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
