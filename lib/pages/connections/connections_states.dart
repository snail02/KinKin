
import 'package:flutter_app/utils/view_model/view_model_state.dart';

abstract class ConnectionsState extends ViewModelState {}

class Idle extends ConnectionsState {
  final Map<Field, String> errors;

  Idle({
    required this.errors,
  });
}

enum Field {
  ERROR_MSG,
}

class UpdateConnectionsInProgress extends ConnectionsState {}
class ErrorUpdate extends ConnectionsState {}