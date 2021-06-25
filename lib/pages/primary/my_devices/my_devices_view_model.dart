import 'package:flutter/material.dart';
import 'package:flutter_app/api/device_api.dart';
import 'package:flutter_app/api/exceptions/dio_exceptions.dart';
import 'package:flutter_app/models/device/device.dart';
import 'package:flutter_app/pages/primary/my_devices/devices_data_response.dart';
import 'package:flutter_app/pages/primary/my_devices/my_devices_events.dart';
import 'package:flutter_app/pages/primary/my_devices/my_devices_states.dart';
import 'package:flutter_app/pages/primary/my_devices/my_devices_view.dart';
import 'package:flutter_app/utils/common_ui/common_notification.dart';
import 'package:flutter_app/utils/view_model/view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDevicesViewModel extends ViewModel<MyDevicesView, MyDevicesState, MyDevicesEvent> {

  final DeviceApi _devicesApi = DeviceApi();

  List <Device>? list;

  MyDevicesViewModel({required MyDevicesView view}) : super(view: view);

  final Map<Field, String> _fieldErrors = {};

  void _addIdleState() {
    statesStreamController.add(
      Idle(
        errors: _fieldErrors,
      ),
    );
  }


  Future<void> updateMyDevices () async {
    _addIdleState();
    if(list==null)
    statesStreamController.add(UpdateMyDevicesInProgress());

    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    if (prefs.get('accessToken') != null) {
      String accessToken = prefs.get('accessToken').toString();

     await _devicesApi.myDevices(token: accessToken).then((devicesDataResponse) {
       _onSuccessUpdateMyDevicesToApi(
           devicesDataResponse: devicesDataResponse);
     }).catchError((e) async {
       if (e is DioExceptions) {
         statesStreamController.add(ErrorUpdate());
        // _addIdleState();
         _showNotificationError(e.message);
       }
       //_addIdleState();
     });

     print("1111111111");
    }
  }


  void _onSuccessUpdateMyDevicesToApi({DevicesDataResponse? devicesDataResponse}) async {
    if (devicesDataResponse!= null) {
        if(devicesDataResponse.result == 'success') {
          list = devicesDataResponse.list!;
        }
       else{
          _showNotificationError('result: Error');
        }
    } else {
      _showNotificationError('Не удалось получить данные');
    }
    print("data load success");
   _addIdleState();
  }


  void _showNotificationError(String message) {
    view.showNotificationBanner(
      CommonUiNotification(
        type: CommonUiNotificationType.ERROR,
        message: message,
      ),
    );
  }

}