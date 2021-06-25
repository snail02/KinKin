import 'package:flutter_app/utils/view_model/view_model_state.dart';

abstract class EventsState extends ViewModelState {}

class Idle extends EventsState {
  final Map<Field, String> errors;

  Idle({
    required this.errors,
  });
}

enum Field {
  ERROR_MSG,
}

class UpdateEventsInProgress extends EventsState {}

class LoadEventsInProgress extends EventsState {}