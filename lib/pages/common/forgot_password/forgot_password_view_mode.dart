import 'package:flutter/material.dart';
import 'package:flutter_app/api/exceptions/api_message.dart';
import 'package:flutter_app/api/exceptions/dio_exceptions.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/pages/common/forgot_password/forgot_password_events.dart';
import 'package:flutter_app/pages/common/forgot_password/forgot_password_states.dart';
import 'package:flutter_app/pages/common/forgot_password/forgot_password_view.dart';
import 'package:flutter_app/pages/common/forgot_password/restore_api.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/utils/common_ui/common_notification.dart';
import 'package:flutter_app/utils/view_model/view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordViewModel extends ViewModel<ForgotPasswordView,
    ForgotPasswordState, ForgotPasswordEvent> {
  final RestoreApi _restoreApi = RestoreApi();

  bool isForgotPasswordError = false;

  ForgotPasswordViewModel({required ForgotPasswordView view})
      : super(view: view);

  final Map<Field, String> _fieldErrors = {};

  void sendForgotPasswordButtonClicked({
    required String email,
    required String lang,
  }) {
    String validField = _isFieldValid(email: email);
    if (validField == 'ok') {
      if (!_isEmailValid(email: email)) {
        _fieldErrors[Field.ERROR_MSG] = LocaleKeys.input_email_invalid.tr();
        isForgotPasswordError = true;
        _addIdleState();
        eventsStreamController.add(ForgotPasswordError());
      } else {
        isForgotPasswordError = false;
        _addIdleState();
        _restorePassword(
          email: email,
          lang: lang,
        );
      }
    } else {
      _fieldErrors[Field.ERROR_MSG] = LocaleKeys.input_mandatory_field.tr(namedArgs: {'field_name': validField});
      isForgotPasswordError = true;
      _addIdleState();
      eventsStreamController.add(ForgotPasswordError());
    }
  }

  bool _isEmailValid({required String email}) {
    String p =
        "[a-zA-Z0-9+.\_\%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9-]{0,64}(.[a-zA-Z0-9][a-zA-Z0-9-]{0,25})+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(email))
      return true;
    else
      return false;
  }

  String _isFieldValid({
    required String email,
  }) {
    if (email.isEmpty) return LocaleKeys.all_email.tr();
    return "ok";
  }

  void _restorePassword({
    required String email,
    required String lang,
  }) async {
    statesStreamController.add(ForgotPasswordInProgress());

    await _restoreApi
        .restorePassword(
      email: email,
      lang: lang,
    )
        .then((apiMessage) {
      _onSuccessRestorePasswordToApi(apiMessage);
    }).catchError((e) async {
      if (e is DioExceptions) {
        _addIdleState();
        showNotif(e.message);
      }
      _addIdleState();
      showNotif('error');
    });
  }

  void _onSuccessRestorePasswordToApi(String restoreDataResponse) async {
    if (restoreDataResponse != "error") {
      String errorMsg = 'not found msg';
      if (restoreDataResponse == 'email_not_found') {
        errorMsg = LocaleKeys.input_email_not_found.tr();
        _fieldErrors[Field.ERROR_MSG] = errorMsg;

        isForgotPasswordError = true;
        _addIdleState();
        eventsStreamController.add(ForgotPasswordError());
      }
      if (restoreDataResponse == 'email_sent') {
        view.openForgotPasswordSendMailPage();
      }
    } else {
      view.showNotificationBanner(
        CommonUiNotification(
          type: CommonUiNotificationType.ERROR,
          message: 'Не удалось получить данные',
        ),
      );
    }
  }

  void showNotif(String message) {
    view.showNotificationBanner(
      CommonUiNotification(
        type: CommonUiNotificationType.ALERT,
        message: message,
      ),
    );
  }

  void _addIdleState() {
    statesStreamController.add(
      Idle(
        errors: _fieldErrors,
      ),
    );
  }
}
