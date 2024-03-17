import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_component/data/firebase_crash.dart';
import 'package:flutter_component/data/spref.dart';

class DioConfigNetwork {
  DioConfigNetwork._();
  static DioConfigNetwork instant = DioConfigNetwork._();
  late BaseOptions _options;
  late Dio dio;
  init({required String baseUrl, BaseOptions? options}) {
    SPref.instant.init();

    _options = options ??
        BaseOptions(
          baseUrl: baseUrl,
          receiveDataWhenStatusError: true,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
        );
    dio = Dio(_options);
    // ignore: deprecated_member_use
    if (!kIsWeb) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    dio.interceptors.addAll([RequestConfig(), ErrorConfig()]);
  }
}

class RequestConfig extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String token = SPref.instant.getToken ?? '';
    if (token.isNotEmpty) {
      options.headers['authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}

class ErrorConfig extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    try {
      final logData = err.response?.data;
      final logRequest = {
        'method': err.response?.requestOptions.method,
        'baseUrl': err.response?.requestOptions.baseUrl,
        'path': err.response?.requestOptions.path,
        'queryParameters': err.response?.requestOptions.queryParameters,
        'data': err.response?.requestOptions.data,
        'headers': err.response?.requestOptions.headers,
      };

      // FirebaseCrash.instant.sendNonFatalError(message: " ${err.message}", exception: err, log: "Request: $logRequest\nResponse: $logData");
    } catch (e) {
      rethrow;
    }
    super.onError(err, handler);
  }
}
