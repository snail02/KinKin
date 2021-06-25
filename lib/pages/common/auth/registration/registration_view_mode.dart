import 'package:flutter/material.dart';
import 'package:flutter_app/api/exceptions/dio_exceptions.dart';
import 'package:flutter_app/api/exceptions/api_message.dart';
import 'package:flutter_app/pages/common/auth/auth_api.dart';
import 'package:flutter_app/pages/common/auth/auth_data_response.dart';
import 'package:flutter_app/pages/common/auth/registration/registration_events.dart';
import 'package:flutter_app/pages/common/auth/registration/registration_states.dart';
import 'package:flutter_app/pages/common/auth/registration/registration_view.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:flutter_app/utils/common_ui/common_notification.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/utils/url_website.dart';
import 'package:flutter_app/utils/view_model/view_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrationViewModel
    extends ViewModel<RegistrationView, RegistrationState, RegistrationEvent> {

  final AuthApi _authApi = AuthApi();

  bool isRegistartionError = false;

  RegistrationViewModel({required RegistrationView view}) : super(view: view);

  final Map<Field, String> _fieldErrors = {};

  void sendCreateAccountButtonClicked({
    required String name,
    required String email,
    required String password,
    required bool agreement,
  }) {
    String validField = _isFieldValid(name: name, email: email, password: password);
    if (validField=='ok') {
      if (!_isEmailValid(email: email)) {
        _fieldErrors[Field.ERROR_MSG] = LocaleKeys.input_email_invalid.tr();
        isRegistartionError = true;
        _addIdleState();
        eventsStreamController.add(RegistrationError());
        return;
      }
      if (!isNormalLengthPassword(password: password)){
        _fieldErrors[Field.ERROR_MSG] = LocaleKeys.input_password_minlength_6.tr();
        isRegistartionError = true;
        _addIdleState();
        eventsStreamController.add(RegistrationError());
        return;
      }
      if(!agreement)
        {
          isRegistartionError = false;
          _addIdleState();
          showNotif('Ознакомьтесь с правилами использованиями');
          return;
        }
      isRegistartionError = false;
      _addIdleState();
        _register(name: name,
            email: email,
            password: password,
            passwordConfirmation: password,
            lang: 'ru');
    } else {
      _fieldErrors[Field.ERROR_MSG] = LocaleKeys.input_mandatory_field.tr(namedArgs: {'field_name': validField});
      isRegistartionError = true;
      _addIdleState();
      eventsStreamController.add(RegistrationError());
      //_addIdleState();
    }
  }

  bool isNormalLengthPassword({required String password}) {
    if (password.length >= 6)
      return true;
    else
      return false;
  }

  void showNotif(String message) {
    view.showNotificationBanner(
      CommonUiNotification(
        type: CommonUiNotificationType.ERROR,
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

  void _register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String lang,
  }) async {
    statesStreamController.add(RegistrationInProgress());
    await _authApi
        .register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      lang: lang,
    )
        .then((authDataResponse) {
      _onSuccessRegistrationToApi(authDataResponse: authDataResponse);
    }).catchError((e) async {
      if (e is ApiMessage) {
        if (e is ApiMessage) {
          String errorMsg = 'error';
          if (e.message == 'Mandatory Field')
            errorMsg = LocaleKeys.input_mandatory_field.tr();
          if (e.message == 'Email Invalid')
            errorMsg = LocaleKeys.input_email_invalid.tr();
          if (e.message == 'The email has already been taken.')
            errorMsg = LocaleKeys.input_email_taken.tr();
          _fieldErrors[Field.ERROR_MSG] = errorMsg;

          isRegistartionError = true;
          _addIdleState();
          eventsStreamController.add(RegistrationError());
        }

      }
      if (e is DioExceptions) {
        _addIdleState();
        showNotif(e.message);
      }
      _addIdleState();
    });
  }

  String  _isFieldValid({
    required String name,
    required String email,
    required String password,
  }) {
    if(name.isEmpty)
      return LocaleKeys.all_name.tr();
    if(email.isEmpty)
      return LocaleKeys.all_email.tr();
    if(password.isEmpty)
      return LocaleKeys.all_password.tr();
    return "ok";
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

  void _onSuccessRegistrationToApi({required AuthDataResponse authDataResponse}) async {
    if (authDataResponse.accessToken != null) {
      if (authDataResponse.accessToken.accessToken.isNotEmpty) {
        view.openRegistrationSuccessfulPage();
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

  Future<void> openWebsitePrivacyPolicy() async{
      if (await canLaunch(urlWebsite.privacyPolicy)) {
        await launch(urlWebsite.privacyPolicy);
      } else {
        showNotif("Could not open the website");
      }

  }

  Future<void> openWebsiteTermsConditions () async{
    if (await canLaunch(urlWebsite.termsConditions)) {
      await launch(urlWebsite.termsConditions);
    } else {
      showNotif("Could not open the website");
    }

  }

}