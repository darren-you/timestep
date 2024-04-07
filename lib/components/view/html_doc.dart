import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/page_path_util.dart';

class HtmlDoc {
  static toServiceDoc() {
    Map<String, dynamic> arg = {
      "appbarBgColor": Colors.white,
      "title": "服务协议",
      "url": "https://singlestep.cn/wejinda/res/doc/service.html"
    };
    Get.toNamed(PagePathUtil.webDocPage, arguments: arg);
  }

  static toPrivateDoc() {
    Map<String, dynamic> arg = {
      "appbarBgColor": Colors.white,
      "title": "隐私政策",
      "url": "https://singlestep.cn/wejinda/res/doc/private.html"
    };
    Get.toNamed(PagePathUtil.webDocPage, arguments: arg);
  }

  static toAboutMe() {
    Map<String, dynamic> arg = {
      "appbarBgColor": Colors.white,
      "title": "关于开发者",
      "url":
          "https://mp.weixin.qq.com/s?__biz=MzIxMTY2MTkxMQ==&mid=2247484377&idx=1&sn=ffd745319ed4064490963ef1c3ccb4d9&chksm=9750a6e1a0272ff7406a95f942d02e6ba3a3baf231e8f9fd0ea03c0e42223a8cbdda71643d14#rd"
    };
    Get.toNamed(PagePathUtil.webDocPage, arguments: arg);
  }

  static toCallBackHtml() {
    Map<String, dynamic> arg = {
      "appbarBgColor": Colors.white,
      "title": "反馈与建议",
      "url": "https://txc.qq.com/products/604215"
    };
    Get.toNamed(PagePathUtil.webDocPage, arguments: arg);
  }

  static toSchoolCalendar() {
    Map<String, dynamic> arg = {
      "appbarBgColor": Colors.white,
      "title": "校历",
      "url": "https://singlestep.cn/wejinda/res/doc/schoolcalendar.html"
    };
    Get.toNamed(PagePathUtil.webDocPage, arguments: arg);
  }

  static toSchoolMap() {
    Map<String, dynamic> arg = {
      "appbarBgColor": Colors.white,
      "title": "校园地图", // todo: 这个地方最好获取html中的title
      "url": "https://singlestep.cn/wejinda/res/doc/schoolmap.html"
    };
    Get.toNamed(PagePathUtil.webDocPage, arguments: arg);
  }
}
