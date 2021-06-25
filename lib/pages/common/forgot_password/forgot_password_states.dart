import 'package:flutter/material.dart';
import 'package:flutter_app/utils/view_model/view_model_state.dart';

abstract class ForgotPasswordState extends ViewModelState {}

class Idle extends ForgotPasswordState {
  final Map<Field, String> errors;

  Idle({
    required this.errors,
  });
}

enum Field {
  ERROR_MSG,
}

class ForgotPasswordInProgress extends ForgotPasswordState {}

class ShowErrorMessage extends ForgotPasswordState {}