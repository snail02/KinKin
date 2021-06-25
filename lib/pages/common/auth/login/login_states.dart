import 'package:flutter/cupertino.dart';
import 'package:flutter_app/utils/view_model/view_model_state.dart';

abstract class LoginState extends ViewModelState {}

class Idle extends LoginState {
  final Map<Field, String> errors;

  Idle({
    required this.errors,
  });
}

enum Field {
  ERROR_MSG,
}

class LoginInProgress extends LoginState {}

class ShowErrorMessage extends LoginState {}