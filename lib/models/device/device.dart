import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/last_location/last_location.dart';

class Device {
  late final int id;
  late final String udid;
  late final String image;
  late final String name;
  late final int? battery;
  late final int message;
  late final int alert;
  late final LastLocation? lastLocation;

  Device(
      {required this.id,
      required this.udid,
      required this.image,
      required this.name,
      this.battery = 0,
      this.message = 0,
      this.alert = 0,
      required this.lastLocation});

  Device.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    udid = json['udid'];
    image = json['image'];
    name = json['name'];
    battery = json['battery'];
    message = json['message_new'];
    alert = json['alert_new'];
    lastLocation = (json['last_location'] != null)? LastLocation.fromJson(jsonDecode(json['last_location'])): null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['udid'] = this.udid;
    data['image'] = this.image;
    data['name'] = this.name;
    data['battery'] = this.battery;
    data['message_new'] = this.message;
    data['alert_new'] = this.alert;
    data['last_location'] = this.lastLocation;
    return data;
  }
}
