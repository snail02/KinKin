import 'package:flutter_app/models/device/commands.dart';
import 'package:flutter_app/models/device/device_detail.dart';
import 'package:flutter_app/models/device/settings/settings.dart';

class DeviceDetailDataResponse {
  String? result;
  DeviceDetail? deviceDetail;
  List<Commands>? commands;
  Settings? settings;

  DeviceDetailDataResponse(
      {this.result, this.deviceDetail, this.commands, this.settings});

  DeviceDetailDataResponse.fromJson(Map<dynamic, dynamic> json) {
    result = json['result'];
    deviceDetail =
        json['item'] != null ?  DeviceDetail.fromJson(json['item']) : null;
    if (json['commands'] != null) {
      commands = <Commands>[];
      json['commands'].forEach((v) {
        commands!.add(Commands.fromJson(v));
      });
    }
    settings = (json['settings'] != null && json['settings'].toString()!="[]")
        ? Settings.fromJson(json['settings'])
        : null;
  }
}
