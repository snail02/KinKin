
import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/api/exceptions/dio_exceptions.dart';

class RestoreApi extends Api{

  Future<String> restorePassword({
    required String email,
    required String lang,
  }) async {

      final Map<dynamic, dynamic> responseMap = await super.request(
        functionName: 'password/forgot',
        method: 'POST',
        body: {
          'email': email,
          'lang': lang,
        },
      );
      if (responseMap['message'] != null)
        return responseMap['message'];
      if (responseMap['error'] != null)
        return responseMap['error'];
      return 'error';
    }



}