
import 'package:flutter_app/api/exceptions/api_functions_exception.dart';

class ApiMessage extends ApiFunctionsException {
  final String _message;

  ApiMessage(this._message);

  String get message => _message;
}