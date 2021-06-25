
import 'package:flutter_app/models/device/device.dart';

class DevicesDataResponse {
  final String? result;
  final List<Device>? list;


  DevicesDataResponse({this.result,
    this.list,
  });

  factory DevicesDataResponse.fromJson(Map<dynamic, dynamic> json) {
    return DevicesDataResponse(
      result: json['result'],
      list: (json["list"] as List)
            .map((i) => Device.fromJson(Map<String, dynamic>.from(i)))
            .toList(),
    );
  }

}