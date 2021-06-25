import 'package:flutter/material.dart';
import 'package:flutter_app/api/exceptions/dio_exceptions.dart';
import 'package:flutter_app/api/exceptions/api_message.dart';
import 'package:flutter_app/pages/common/auth/auth_api.dart';
import 'package:flutter_app/pages/common/auth/auth_data_response.dart';
import 'package:flutter_app/pages/common/auth/login/login_events.dart';
import 'package:flutter_app/pages/common/auth/login/login_states.dart';
import 'package:flutter_app/pages/common/auth/login/login_view.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:flutter_app/utils/common_ui/common_notification.dart';
import 'package:flutter_app/utils/view_model/view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ViewModel<LoginView, LoginState, LoginEvent> {

  final AuthApi _authApi = AuthApi();

  bool isLoginError = false;

  LoginViewModel({required LoginView view}) : super(view: view);


  final Map<Field, String> _fieldErrors = {};


  void sendLoginButtonClicked({
    required String email,
    required String password,
  }) {
    String validField = _isFieldValid(email: email, password: password);
    if (validField=='ok') {
      if (!_isEmailValid(email: email)) {
        _fieldErrors[Field.ERROR_MSG] = LocaleKeys.input_email_invalid.tr();
        isLoginError = true;
        _addIdleState();
        eventsStreamController.add(LoginError());
      }
      else {
        isLoginError = false;
        _addIdleState();
        _login(email: email, password: password);
      }
    } else {
      _fieldErrors[Field.ERROR_MSG] = LocaleKeys.input_mandatory_field.tr(namedArgs: {'field_name': validField});
      isLoginError = true;
      _addIdleState();
      eventsStreamController.add(LoginError());
      //_addIdleState();
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
    required String password,
  }) {
    if(email.isEmpty)
      return LocaleKeys.all_email.tr();
    if(password.isEmpty)
      return LocaleKeys.all_password.tr();
    return ('ok');
  }

  void _login({
    required String email,
    required String password,
  }) async {
    statesStreamController.add(LoginInProgress());
    await _authApi
        .login(
      email: email,
      password: password,
    )
        .then((authDataResponse) {
      _onSuccessLoginToApi(authDataResponse);
    }).catchError((e) async {
      if (e is ApiMessage) {
        String errorMsg = 'error';
        if (e.message == 'Invalid Credentials')
          errorMsg = LocaleKeys.input_invalid_credentials.tr();
        if (e.message == 'Email Invalid')
          errorMsg = LocaleKeys.input_email_invalid.tr();
        _fieldErrors[Field.ERROR_MSG] = errorMsg;

        isLoginError = true;
        _addIdleState();
        eventsStreamController.add(LoginError());
      }
      if(e is DioExceptions){
        _addIdleState();
        showNotif(e.message);
      }
    });
  }

  void _saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', token);
  }

  void _onSuccessLoginToApi(AuthDataResponse authDataResponse) async {
    if (authDataResponse.accessToken != null) {
      if (authDataResponse.accessToken.accessToken.isNotEmpty) {
        _saveToken(authDataResponse.accessToken.accessToken);
        view.openPrimaryPage();
      } else
        view.showNotificationBanner(
          CommonUiNotification(
            type: CommonUiNotificationType.ERROR,
            message: 'empty token',
          ),
        );
    } else {
      view.showNotificationBanner(
        CommonUiNotification(
          type: CommonUiNotificationType.ERROR,
          message: 'Не удалось получить данные о пользователе',
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
