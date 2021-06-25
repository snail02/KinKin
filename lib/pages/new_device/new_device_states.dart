import 'package:flutter/material.dart';
import 'package:flutter_app/utils/view_model/view_model_state.dart';

abstract class NewDeviceState extends ViewModelState {}

class Idle extends NewDeviceState {
  final Map<Field, String> errors;

  Idle({
    required this.errors,
  });
}

enum Field {
  ERROR_MSG,
}

class AddDeviceInProgress extends NewDeviceState {}
