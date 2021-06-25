import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/error_interceptor.dart';

import 'exceptions/dio_exceptions.dart';

abstract class Api {
  static final options = BaseOptions(
    baseUrl: 'https://backend.kinkin.net/api/',
    connectTimeout: 20000,
    receiveTimeout: 9000,
  );

  // Dio dio = Dio(options)..interceptors.add(ErrorInterceptor());
  Dio dio = Dio(options);

  @protected
  Future<Map<dynamic, dynamic>> request({
    required String functionName,
    required String method,
    String? token,
    Map<String, dynamic> body = const {},
    Map<String, dynamic>? queryParameters = const {},
  }) async {
    try {
      final response = await dio.request(
        functionName,
        data: body,
        queryParameters: queryParameters,
        options: Options(
            method: method, headers: {"Authorization": "Bearer ${token}"}),
      );

      final Map<dynamic, dynamic> data = response.data;
      return data;
    } catch (e) {
      if (e is DioError)
        throw DioExceptions.fromDioError(e);
      else
        throw e;
    }
  }

  @protected
  Future<Map<dynamic, dynamic>> upload({
    required String functionName,
    required String method,
    String? token,
    required FormData body,
  }) async {
    try {
      final response = await dio.request(
        functionName,
        data: body,
        options: Options(
            method: method, headers: {"Authorization": "Bearer ${token}"}),
      );

      final Map<dynamic, dynamic> data = response.data;
      return data;
    } catch (e) {
      if (e is DioError)
        throw DioExceptions.fromDioError(e);
      else
        throw e;
    }
  }
}
