import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/appbar/normal_appbar.dart';
import '../../../components/notification/custom_notification.dart';
import '../../../components/view/custom_body.dart';
import '../../../components/view/html_doc.dart';
import '../../../components/view/setting_item_text.dart';
import '../../../enumm/appbar_enum.dart';
import '../../../enumm/color_enum.dart';
import '../../../utils/app_info_util.dart';
import '../../../utils/page_path_util.dart';
import 'about_wejinda_page_vm.dart';

class AboutWejindaPage extends GetView<AboutWejindaPageViewModel> {
  const AboutWejindaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background.color,
      body: CustomBody(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        appBar: const NormalAppBar(
            title: Text(
          "关于We锦大",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        )),
        body: Column(
          children: [
            SizedBox(
              height: context.height -
                  AppBarOptions.hight50.height -
                  context.mediaQuery.padding.top -
                  context.mediaQuery.padding.bottom,
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
                    child: Column(
                      children: [
                        SettingItemText(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          text: "We锦大官网",
                          onTap: () {
                            debugPrint("点击 We锦大官网");
                            CustomNotification.toast(
                              context,
                              '在写啦⌨️',
                            );
                          },
                        ),
                        SettingItemText(
                          text: "版本更新",
                          onTap: () {
                            debugPrint("点击 版本更新");
                            Get.toNamed(PagePathUtil.appUpdatePage);
                          },
                        ),
                        SettingItemText(
                          text: "反馈与建议",
                          onTap: () {
                            debugPrint("点击 反馈与建议");
                            HtmlDoc.toCallBackHtml();
                          },
                        ),
                        SettingItemText(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          text: "关于开发者",
                          onTap: () {
                            debugPrint("点击 关于开发者");
                            HtmlDoc.toAboutMe();
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      //color: Colors.pink,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  HtmlDoc.toServiceDoc();
                                },
                                child: const Text(
                                  "服务协议",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const Text(" ｜ "),
                              GestureDetector(
                                onTap: () {
                                  HtmlDoc.toPrivateDoc();
                                },
                                child: const Text(
                                  "隐私政策",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: const Text(
                              "Copyright © 2022-2023 青白江游同学网络工作室.ALL Rights Reservrd",
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
