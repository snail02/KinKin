import 'package:flutter/cupertino.dart';

/// Уведомление пользователя о событии
class CommonUiNotification {
  /// Текст уведомления
  final String message;

  /// Тип уведомления
  final CommonUiNotificationType type;

  CommonUiNotification({
    required this.type,
    required this.message,
  });
}

enum CommonUiNotificationType {
  ERROR,
  ALERT,
  SENTCOMMAND,
}
