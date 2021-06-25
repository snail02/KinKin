import 'package:flutter/material.dart';
import 'package:flutter_app/utils/view_model/view_model_state.dart';

abstract class DeviceDetailState extends ViewModelState {}

class Idle extends DeviceDetailState {
  final Map<Field, String> errors;

  Idle({
    required this.errors,
  });
}

enum Field {
  ERROR_MSG,
}

class UpdateDeviceDetailInProgress extends DeviceDetailState {}
class SendingDataInProgress extends DeviceDetailState {}
