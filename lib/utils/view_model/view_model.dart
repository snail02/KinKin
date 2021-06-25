import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/utils/common_ui/common_notification.dart';
import 'package:flutter_app/utils/view_model/view.dart';
import 'package:flutter_app/utils/view_model/view_model_event.dart';
import 'package:flutter_app/utils/view_model/view_model_state.dart';


/// Родительский класс для всех view model в приложении
/// T - базовый класс событий view model
/// U - базовый класс для view
abstract class ViewModel<V extends View, S extends ViewModelState, E extends ViewModelEvent> {
  /// Контроллер для состояний view model
  @protected
  final StreamController<S> statesStreamController = StreamController<S>.broadcast();

  /// Контроллер для событый view model
  @protected
  final StreamController<E> eventsStreamController = StreamController<E>.broadcast();

  /// Контроллер для событый view model
  @protected
  final StreamController<CommonUiNotification> notificationsStreamController = StreamController<CommonUiNotification>.broadcast();

  /// Поток событий view model
  Stream<S> get statesStream => statesStreamController.stream;

  /// Поток событий view model
  Stream<E> get eventsStream => eventsStreamController.stream;


  /// View, привязанная ко view model
  @protected
  final V view;

  ViewModel({required this.view}) {
    _superInit();
    init();
  }

  /// Инициализация ресурсов, используемых во view model
  void _superInit() {
    print("init called for $runtimeType");
    eventsStream.listen((event) {
      print("new event from $runtimeType = ${(event as ViewModelEvent).runtimeType}");
    });
    statesStream.listen((state) {
      print("new state from $runtimeType = ${(state as ViewModelState).runtimeType}");
    });
  }


  /// Инициализация ресурсов, используемых во view model
  @protected
  @mustCallSuper
  void init() {

  }

  /// Высвобождение ресурсов, используемых во view model
  /// Нужно вызывать из метода dispose виджета, к которому привязана view model
  @protected
  @mustCallSuper
  void dispose() {
    statesStreamController.close();
    eventsStreamController.close();
  }
}