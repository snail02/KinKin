
import 'package:flutter_app/utils/view_model/view_model_state.dart';

abstract class NewConnectionState extends ViewModelState {}

class Idle extends NewConnectionState {
  final Map<Field, String> errors;

  Idle({
    required this.errors,
  });
}

enum Field {
  ERROR_MSG,
}

class UpdateConnectionDeviceInProgress extends NewConnectionState {}
