import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/api/exceptions/api_message.dart';
import 'package:flutter_app/api/exceptions/dio_exceptions.dart';
import 'package:flutter_app/pages/common/auth/auth_data_response.dart';

class AuthApi extends Api {
  Future<AuthDataResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String lang,
  }) async {

      final Map<dynamic, dynamic> responseMap = await super.request(
        functionName: 'register',
        method: 'POST',
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'lang': lang,
        },
      );
      if (responseMap['message'] != null)
        throw ApiMessage(responseMap['message']);
      if (responseMap['error'] != null)
        throw ApiMessage(
            responseMap['error']['email'][0].toString());
      return AuthDataResponse.fromJson(responseMap);

  }


  Future<AuthDataResponse> login({
    required String email,
    required String password,
  }) async {
      final Map<dynamic, dynamic> responseMap = await super.request(
        functionName: 'login',
        method: 'POST',
        body: {
          'email': email,
          'password': password,
        },
      );
      if (responseMap['message'] != null)
        throw ApiMessage(responseMap['message']);
      if (responseMap['error'] != null)
        throw DioExceptions.setMessage(
            responseMap['error'].toString());
      return AuthDataResponse.fromJson(responseMap);

  }
}
