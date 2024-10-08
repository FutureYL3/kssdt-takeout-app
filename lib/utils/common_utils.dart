import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CommonUtilsApiService {
  static const String baseUrl = 'http://114.55.108.97:8080';
  late Dio _dio;

  CommonUtilsApiService() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    _dio = Dio(options);

    // // 添加拦截器
    // _dio.interceptors.add(InterceptorsWrapper(
    //   onRequest: (options, handler) {
    //     // 在请求发送之前做一些处理
    //     print('Request: ${options.method} ${options.path}');
    //     return handler.next(options); // Continue the request
    //   },
    //   // onResponse: (response, handler) {
    //   //   // 在响应数据返回之前做一些处理
    //   //   print('Response: ${response.statusCode} ${response.data}');
    //   //   return handler.next(response); // Continue the response
    //   // },
    //   onError: (DioException e, handler) {
    //     // 在发生错误时做一些处理
    //     print('Error: ${e.response?.statusCode} ${e.message}');
    //     return handler.next(e); // Continue the error
    //   },
    // ));
  }

  Future<Map<String, dynamic>> getValidationCode(String phoneNumber) async {
    try {
      // 发起 GET 请求，并将 phoneNumber 作为参数
      Response response = await _dio.get('/common/phone', queryParameters: {
        'phoneNumber': phoneNumber,
      });

      // 返回响应数据
      return response.data;
    } on DioException {
      // 处理 Dio 的错误
      return {
        'error': true
      };
    }
  }

  // TODO: 添加一个新的方法，用于验证验证码
  Future<Map<String, dynamic>> checkValidationCode(String phoneNumber, String validationCode) async {
    try {
      // 发起 POST 请求，并将 phoneNumber 和 validationCode 作为参数
      Response response = await _dio.post('/common/phone', data: {
        'phoneNumber': phoneNumber,
        'validationCode': validationCode,
      });

      // 返回响应数据
      return response.data;
    } on DioException {
      // 处理 Dio 的错误
      return {
        'error': true
      };
    }
  }
}

void showSnackBar(String title, String msg, ContentType type, BuildContext ctx) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: title,
      message: msg,
      contentType: type,
    ),
  );

  ScaffoldMessenger.of(ctx)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
