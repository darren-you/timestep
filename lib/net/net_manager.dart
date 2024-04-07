import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../components/view/we_chat_loading.dart';
import '../enumm/net_page_state_enum.dart';
import 'base_response.dart';

// 定义网络请求完成、获取正确数据、获取错误数据、请求错误、dio错误回调方法
typedef OnDataSuccess = Future<void> Function(dynamic rightData);
typedef OnDataError = Future<void> Function(BaseResponse errorData);
typedef OnNetError = Future<void> Function(String errorData);
typedef OnDioException = Future<void> Function(DioException dioException);
typedef OnNetDone<T> = Future<void> Function(T response);

class NetManager {
  NetManager._();
  /*
      执行 HTTP 请求
      使用 Rx<NetPageStateEnum> 参数来标记网络请求状态，非必需
      使用 RxString 参数标记网络请求错误的信息，非必需
   */
  static Future request({
    required Future netFun,
    bool autoPageStateSucc = true,
    Rx<NetPageStateEnum>? netPageState,
    RxString? errorData,
    OnDataSuccess? onDataSuccess,
    OnDataError? onDataError,
    OnNetError? onNetError,
    OnDioException? onDioException,
    OnNetDone? onNetDone,
    bool enableLoadingDialog = true,
    bool enableShowErrorMsg = true,
  }) async {
    dynamic response;
    // 更改网络标记状态
    netPageState?.value = NetPageStateEnum.pageLoading;

    // 此处根据界面上是否存在Dialog，决定是否再显示Dialog
    if (!SmartDialog.config.checkExist() && enableLoadingDialog) {
      SmartDialog.show(
        backDismiss: false,
        clickMaskDismiss: false,
        maskColor: Colors.transparent,
        useAnimation: false,
        builder: (BuildContext context) {
          return const CircleLoadingIndicator();
        },
      );
    }

    // 开始HTTP请求
    try {
      response = await netFun;

      if (response is dio.Response) {
        if (response.statusCode == HttpStatus.ok) {
          final baseResponse =
              BaseResponse.fromJson(jsonDecode(response.toString()));
          if (int.parse(baseResponse.code) == HttpStatus.ok) {
            await onDataSuccess?.call(baseResponse.result);
            if (autoPageStateSucc) {
              netPageState?.value = NetPageStateEnum.pageSuccess;
              debugPrint("请求成功 刷新 > > > ");
            }
          } else {
            await onDataError?.call(baseResponse);
            netPageState?.value = NetPageStateEnum.pageError;
            errorData?.value = baseResponse.toString();
            if (enableShowErrorMsg) {
              SmartDialog.showToast(baseResponse.message);
            }
          }
        } else {
          // http请求失败，状态码非200
          await onNetError?.call(response.toString());
          netPageState?.value = NetPageStateEnum.pageError;
          errorData?.value = response.toString();
          if (enableShowErrorMsg) {
            SmartDialog.showToast("NetWork Error: ${response.toString()}");
          }
        }
      }
    } on DioException catch (e) {
      await onDioException?.call(e);
      errorData?.value = response.message;
      netPageState?.value = NetPageStateEnum.pageError;
      if (enableShowErrorMsg) {
        SmartDialog.showToast("Dio Error: ${response.message}");
      }
    }
    // catch (e) {
    //   await onNetError?.call(response.toString());
    //   errorData?.value = response.message;
    //   netPageState?.value = NetPageStateEnum.pageError;
    //   if (enableShowErrorMsg) {
    //     SmartDialog.showToast("Error: $e}");
    //   }
    // }
    finally {
      SmartDialog.dismiss();
      if (netPageState?.value == NetPageStateEnum.pageLoading) {
        netPageState?.value = NetPageStateEnum.pageDown;
        onNetDone?.call(response);
      } else {
        onNetDone?.call(response);
      }
    }
  }
}
