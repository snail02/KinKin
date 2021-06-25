

import 'package:flutter_app/utils/common_ui/common_notification.dart';

/// Базовый класс для всех view, для связки с view model
abstract class View {
  void showNotificationBanner(CommonUiNotification notification);
}