
import 'package:flutter_app/models/device/connected_device.dart';

class ConnectionsDataResponse {
  String? result;
  List<ConnectedDevice>? connectedDevices;

  ConnectionsDataResponse({this.result, this.connectedDevices, });

  ConnectionsDataResponse.fromJson(Map<dynamic, dynamic> json) {
    result = json['result'];
    if (json['list'] != null) {
      connectedDevices = <ConnectedDevice>[];
      json['list'].forEach((v) {
        connectedDevices!.add(new ConnectedDevice.fromJson(v));
      });
    }
  }

}