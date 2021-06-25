import 'package:flutter/material.dart';
import 'package:flutter_app/utils/view_model/view_model_state.dart';

abstract class RegistrationState extends ViewModelState {}

class Idle extends RegistrationState {
  final Map<Field, String> errors;

  Idle({
    required this.errors,
  });
}

enum Field {
  ERROR_MSG,
}

class RegistrationInProgress extends RegistrationState {}

class ShowErrorMessage extends RegistrationState {}