import 'package:flutter/material.dart';
import 'package:flutter_app/api/device_api.dart';
import 'package:flutter_app/api/exceptions/dio_exceptions.dart';
import 'package:flutter_app/pages/new_device/add_device_data_response.dart';
import 'package:flutter_app/pages/new_device/new_device_events.dart';
import 'package:flutter_app/pages/new_device/new_device_states.dart';
import 'package:flutter_app/pages/new_device/new_device_view.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:flutter_app/utils/common_ui/common_notification.dart';
import 'package:flutter_app/utils/view_model/view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewDeviceViewModel
    extends ViewModel<NewDeviceView, NewDeviceState, NewDeviceEvent> {
  final DeviceApi _deviceApi = DeviceApi();

  NewDeviceViewModel({required NewDeviceView view}) : super(view: view);

  final Map<Field, String> _fieldErrors = {};

  void sendAddNewDeviceButtonClicked({
    required String udId,
    required String name,
    required String phoneNumber,
    String? simLogin,
    String? simPassword,
  }) {
    String statusFieldValid =
        _isFieldValid(udId: udId, name: name, phoneNumber: phoneNumber);
    if (statusFieldValid == 'ok') {
      if (_isPhoneNumber(phoneNumber)) {
        _addIdleState();
        _addNewDevice(
            udId: udId,
            name: name,
            phoneNumber: phoneNumber,
            simLogin: simLogin,
            simPassword: simPassword);
      } else {
        view.showNotificationBanner(
          CommonUiNotification(
              type: CommonUiNotificationType.ALERT,
              message: "Invalid phone number"),
        );
      }
    } else {
      view.showNotificationBanner(
        CommonUiNotification(
            type: CommonUiNotificationType.ALERT,
            message: LocaleKeys.input_mandatory_field
                .tr(namedArgs: {'field_name': statusFieldValid})),
      );
    }
  }

  void _addIdleState() {
    statesStreamController.add(
      Idle(
        errors: _fieldErrors,
      ),
    );
  }

  bool _isPhoneNumber(String phoneNumber) {
    RegExp regExp = RegExp(r'^(?:[+0])?[0-9]{11}$');

    if (regExp.hasMatch(phoneNumber))
      return true;
    else
      return false;
  }

  String _isFieldValid({
    required String udId,
    required String name,
    required String phoneNumber,
  }) {
    if (udId.isEmpty) return LocaleKeys.all_id.tr();
    if (name.isEmpty) return LocaleKeys.all_name.tr();
    if (phoneNumber.isEmpty) return LocaleKeys.all_phone_number.tr();
    return "ok";
  }

  void _addNewDevice({
    required String udId,
    required String name,
    required String phoneNumber,
    String? simLogin,
    String? simPassword,
  }) async {
    statesStreamController.add(AddDeviceInProgress());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('accessToken') != null) {
      String accessToken = prefs.get('accessToken').toString();
      await _deviceApi
          .addNewDevice(
              udId: udId,
              name: name,
              phoneNumber: phoneNumber,
              simLogin: simLogin,
              simPassword: simPassword,
              token: accessToken)
          .then((addDeviceDataResponse) {
        _onSuccessAddedDeviceToApi(
            addDeviceDataResponse: addDeviceDataResponse);
      }).catchError((e) async {
        if (e is DioExceptions) {
          _addIdleState();
          _showNotificationError(e.message);
        }
        _addIdleState();
      });
    } else {
      _addIdleState();
      _showNotificationError("Empty token");
    }
  }

  void _showNotificationError(String message) {
    view.showNotificationBanner(
      CommonUiNotification(
        type: CommonUiNotificationType.ERROR,
        message: message,
      ),
    );
  }

  void _onSuccessAddedDeviceToApi(
      {AddDeviceDataResponse? addDeviceDataResponse}) async {
    if (addDeviceDataResponse != null) {
      if (addDeviceDataResponse.result != null) {
        if (addDeviceDataResponse.result == 'success') {
          view.closeNewDevicePage();
        }
        if (addDeviceDataResponse.result == 'error') {
          if (addDeviceDataResponse.message == "device_not_found") {
            view.showNotificationBanner(
              CommonUiNotification(
                type: CommonUiNotificationType.ALERT,
                message: "Device not found",
              ),
            );
          }
        }
      } else
        _showNotificationError('empty token');
    } else {
      _showNotificationError('Не удалось получить данные');
    }
    _addIdleState();
  }
}
