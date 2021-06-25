


import 'package:flutter_app/api/device_api.dart';
import 'package:flutter_app/api/exceptions/dio_exceptions.dart';
import 'package:flutter_app/api/response/connections_data_response.dart';
import 'package:flutter_app/models/device/connected_device.dart';
import 'package:flutter_app/pages/new_connection/new_connection_events.dart';
import 'package:flutter_app/pages/new_connection/new_connection_states.dart';
import 'package:flutter_app/pages/new_connection/new_connection_view.dart';
import 'package:flutter_app/utils/common_ui/common_notification.dart';
import 'package:flutter_app/utils/view_model/view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewConnectionViewModel extends ViewModel<NewConnectionView, NewConnectionState, NewConnectionEvent> {

  final DeviceApi _devicesApi = DeviceApi();

  NewConnectionViewModel({required NewConnectionView view}) : super(view: view);

  final Map<Field, String> _fieldErrors = {};

  void _addIdleState() {
    statesStreamController.add(
      Idle(
        errors: _fieldErrors,
      ),
    );
  }

  // Future<void> updateConnections({required int id}) async {
  //   if (connectedDevices.isEmpty)
  //     statesStreamController.add(UpdateConnectionsInProgress());
  //
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (prefs.get('accessToken') != null) {
  //     String accessToken = prefs.get('accessToken').toString();
  //
  //     await _devicesApi
  //         .connections(token: accessToken, id: id)
  //         .then((connectionsDataResponse) {
  //       _onSuccessUpdateConnectionsToApi(
  //           connectionsDataResponse: connectionsDataResponse);
  //     }).catchError((e) async {
  //       if (e is DioExceptions) {
  //         //_addIdleState();
  //         _showNotificationError(e.message);
  //       }
  //     });
  //     _addIdleState();
  //   }
  //   _addIdleState();
  // }
  //
  // void _onSuccessUpdateConnectionsToApi(
  //     {ConnectionsDataResponse? connectionsDataResponse}) async {
  //   if (connectionsDataResponse != null) {
  //     if (connectionsDataResponse.result == 'success') {
  //       connectedDevices = connectionsDataResponse.connectedDevices!;
  //     } else {
  //       _showNotificationError('result: Error');
  //     }
  //   } else {
  //     _showNotificationError('Не удалось получить данные');
  //   }
  //   print("data load success");
  //   _addIdleState();
  // }

  void _showNotificationError(String message) {
    view.showNotificationBanner(
      CommonUiNotification(
        type: CommonUiNotificationType.ERROR,
        message: message,
      ),
    );
  }


}