import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'common_notification.dart';

mixin NotificationsMixin<T extends StatefulWidget> on State<T> {
  void showNotificationBanner(CommonUiNotification notification) {
    Flushbar(
      margin: EdgeInsets.all(12),
      //borderRadius: 8,
      borderRadius: BorderRadius.all(Radius.circular(8)),
      title: (getTitle(notification.type) != '')
          ? getTitle(notification.type)
          : null,
      message: notification.message,
      backgroundColor: getColor(notification.type),
      flushbarPosition: FlushbarPosition.TOP,
      icon: Icon(
        Icons.report_gmailerrorred_outlined,
        color: Colors.white,
      ),
      duration: Duration(seconds: 3),
    ).show(context);
  }

  String getTitle(CommonUiNotificationType type) {
    switch (type) {
      case CommonUiNotificationType.ERROR:
        return 'Error';
      case CommonUiNotificationType.ALERT:
        return 'Attention';
      case CommonUiNotificationType.SENTCOMMAND:
        return '';

      default:
        return "";
    }
  }

  Color getColor(CommonUiNotificationType type) {
    switch (type) {
      case CommonUiNotificationType.ERROR:
        return Theme.of(context).errorColor;
      case CommonUiNotificationType.ALERT:
        return Colors.black87;
      case CommonUiNotificationType.SENTCOMMAND:
        return Colors.green;

      default:
        return Colors.black87;
    }
  }
}
