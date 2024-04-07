import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import 'api_path_util.dart';

enum DioConfig {
  defaultBaseUrl(key: "defaultBaseUrl"),
  otherBaseUrl(key: "otherBaseUrl");

  final String key;

  const DioConfig({
    required this.key,
  });
}

class DioUtil {
  DioUtil._privateConstructor();
  static final DioUtil _instance = DioUtil._privateConstructor();
  factory DioUtil() {
    return _instance;
  }

  static late Dio _defaultBaseUrlDio;
  static late Dio _otherBaseUrlDio;
  static late BaseOptions _defaultOptions;

  // dio初始化配置 https://github.com/cfug/dio/blob/main/dio/README-ZH.md -> 【请求配置】
  static void _defaultBaseUrl({String? loginToken}) {
    debugPrint("初始化Dio✅ 带BASE_URL > > > ${ApiPathUtil.getSpringBootBaseUrl()}");
    _defaultOptions = BaseOptions(
        baseUrl: ApiPathUtil.getSpringBootBaseUrl(),
        contentType: Headers.jsonContentType);
    _defaultBaseUrlDio = Dio(_defaultOptions);
    if (null != loginToken) {
      // 添加拦截器
      _defaultBaseUrlDio.interceptors.add(InterceptorsWrapper(onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        var customHeaders = {'loginToken': loginToken};
        options.headers.addAll(customHeaders);
        return handler.next(options); // continue
      }));
    }
  }

  static void _otherBaseUrl() {
    debugPrint("初始化Dio✅, 不带BASE_URL");
    _otherBaseUrlDio = Dio();
  }

  static void init() {
    _defaultBaseUrl();
    _otherBaseUrl();
  }

  static void initDioConfig(DioConfig dioConfig, {String? loginToken}) {
    if (dioConfig == DioConfig.defaultBaseUrl) {
      _defaultBaseUrl(loginToken: loginToken);
    } else if (dioConfig == DioConfig.otherBaseUrl) {
      _otherBaseUrl();
    }
  }

  // get请求
  static Future<dynamic> get(url,
      {bool useDefaultBaseUrl = true,
      Object? data,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    final dio = useDefaultBaseUrl ? _defaultBaseUrlDio : _otherBaseUrlDio;
    debugPrint(
        '< < <   Get请求   > > > \n------baseUrl: ${dio.options.baseUrl} \n------path:$url \n------header(请求头信息):$options \n------query(url参数):$queryParameters \n------body:$data');
    try {
      Response response = await dio.get(url,
          data: data, queryParameters: queryParameters, options: options);
      debugPrint('< < <   Get结果   > > > \n------result:${response.data}');
      return response;
    } on DioException catch (e) {
      debugPrint(
          '< < <   Get请求失败   > > > \n------错误类型:${e.type} \n------错误信息:$e');
      return e;
    }
  }

  // Post请求
  static Future<dynamic> post(url,
      {bool useDefaultBaseUrl = true,
      Object? data,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    final dio = useDefaultBaseUrl ? _defaultBaseUrlDio : _otherBaseUrlDio;
    debugPrint(
        '< < <   Post请求   > > > \n------baseUrl: ${dio.options.baseUrl} \n------path:$url \n------header(请求头信息):$options \n------query(url参数):$queryParameters \n------body:$data');
    try {
      Response response = await dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      debugPrint('< < <   Post结果   > > > \n------result:${response.data}');
      return response;
    } on DioException catch (e) {
      debugPrint(
          '< < <   Post请求失败   > > > \n------错误类型:${e.type} \n------ 错误信息:$e');
      return e;
    }
  }
}
