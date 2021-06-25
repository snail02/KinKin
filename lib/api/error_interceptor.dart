import 'package:dio/dio.dart';
import 'package:flutter_app/api/exceptions/dio_exceptions.dart';

class ErrorInterceptor extends Interceptor{

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    return DioExceptions.fromDioError(err);
  }
}