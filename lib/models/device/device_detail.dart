
import 'dart:convert';

import 'package:flutter_app/models/device/tracker_model.dart';
import 'package:flutter_app/models/last_location/last_location.dart';
import 'package:flutter_app/models/sim/info_of_sim.dart';
import 'package:flutter_app/models/sim/sim_balance.dart';

class DeviceDetail {
  final int id;
  final String? createdAt;
  final String updatedAt;
  final String? platform;
  final String? os;
  final String udid;
  final String? childId;
  final String? pushId;
  final String? accessToken;
  final String name;
  final String type;
  final String phoneNumber;
  final String? simLogin;
  final String? simPassword;
  final int userId;
  final String? image;
  final String? simOperator;
  SimBalance? simBalance;
  final int? simUpdated;
  final int state;
  final String? imei;
  final int? modelId;
  final LastLocation? lastLocation;
  final int? battery;
  final int? messageNew;
  final int? alertNew;
  final TrackerModel? trackerModel;

  DeviceDetail(
      {required this.id,
      this.createdAt,
      required this.updatedAt,
      this.platform,
      this.os,
      required this.udid,
      this.childId,
      this.pushId,
      this.accessToken,
      required this.name,
      required this.type,
      required this.phoneNumber,
      this.simLogin,
      this.simPassword,
      required this.userId,
      this.image,
      this.simOperator,
      this.simBalance,
      this.simUpdated,
      required this.state,
      this.imei,
      required this.modelId,
      this.lastLocation,
      this.battery,
      this.messageNew,
      this.alertNew,
      this.trackerModel});

  factory DeviceDetail.fromJson(Map<String, dynamic> json) {
    return DeviceDetail(
      id: json['id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      platform: json['platform'],
      os: json['os'],
      udid: json['udid'],
      childId: json['child_id'],
      pushId: json['push_id'],
      accessToken: json['access_token'],
      name: json['name'],
      type: json['type'],
      phoneNumber: json['phone_number'],
      simLogin: json['sim_login'],
      simPassword: json['sim_password'],
      userId: json['user_id'],
      image: json['image'],
      simOperator: json['sim_operator'],
      simBalance: json['sim_balance'] != null
          ? SimBalance.fromJson(jsonDecode(json['sim_balance']))
          : null,
      simUpdated: json['sim_updated'],
      state: json['state'],
      imei: json['imei'],
      modelId: json['model_id'],
      lastLocation: json['last_location']!=null ? LastLocation.fromJson(jsonDecode(json['last_location'])) : null,
      battery: json['battery'],
      messageNew: json['message_new'],
      alertNew: json['alert_new'],
      trackerModel: json['tracker_model']!=null ? TrackerModel.fromJson(json['tracker_model']) : null,
    );

  }

  InfoOfSim? getInfoOfSim() {
    InfoOfSim? infoOfSim = (simOperator!=null || simUpdated!=null || simBalance!=null )? InfoOfSim(simOperator, simUpdated, simBalance) : null;
    return infoOfSim;
  }
}
