

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/api/response/connections_data_response.dart';
import 'package:flutter_app/api/result_response.dart';
import 'package:flutter_app/pages/device_detail/device_detail_data_response.dart';
import 'package:flutter_app/pages/device_detail/events_data_response.dart';
import 'package:flutter_app/pages/new_device/add_device_data_response.dart';
import 'package:flutter_app/pages/primary/my_devices/devices_data_response.dart';

class DeviceApi extends Api {


  Future<AddDeviceDataResponse> addNewDevice({
    required String  udId,
    required String name,
    required String phoneNumber,
    String? simLogin,
    String? simPassword,
    required String token,
  }) async {
    final Map<dynamic, dynamic> responseMap = await super.request(
      functionName: 'tracker',
      method: 'POST',
      token: token,
      body: {
        'udid': udId,
        'name': name,
        'phone_number': phoneNumber,
        if(simLogin!=null) 'sim_login': simLogin,
        if(simPassword!=null) 'sim_password': simPassword,
      },
    );

    return AddDeviceDataResponse.fromJson(responseMap);

  }


  Future<DevicesDataResponse> myDevices({
    required String token,
  }) async {
    final Map<dynamic, dynamic> responseMap = await super.request(
      functionName: 'trackers',
      method: 'GET',
      token: token,
    );

    return DevicesDataResponse.fromJson(responseMap);

  }


  Future<DeviceDetailDataResponse> deviceDetail({
    required int id,
    required String token,
  }) async {
    final Map<dynamic, dynamic> responseMap = await super.request(
      functionName: 'device/${id.toString()}',
      method: 'GET',
      token: token,
    );

    return DeviceDetailDataResponse.fromJson(responseMap);

  }

  Future<EventsDataResponse> events({
    required String token,
    required int id,
    int? limit,
  }) async {
    final Map<dynamic, dynamic> responseMap = await super.request(
      functionName: 'device/${id.toString()}/events',
      method: 'GET',
      token: token,
      queryParameters: {
        'limit': limit,
      },
    );

    return EventsDataResponse.fromJson(responseMap);

  }


  Future<ResultResponse> sendVoiceMessage({
    required String token,
    required int id,
    required String fileName,
    required String filePath,
    required String type,
    required String ext,
  }) async {
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
      'type': type,
      'ext': ext,

    });
    final Map<dynamic, dynamic> responseMap = await super.upload(
      functionName: 'device/${id.toString()}/upload',
      method: 'POST',
      token: token,
      body: formData,
    );

    return ResultResponse.fromJson(responseMap);

  }

  Future<ResultResponse> sendTextMessage({
    required String token,
    required int id,
    required String message,
  }) async {
    final Map<dynamic, dynamic> responseMap = await super.request(
      functionName: 'device/${id.toString()}/send',
      method: 'POST',
      token: token,
      body: {
        'command_code': "send_message",
        'command': "MESSAGE",
        //'command': "MESSAGE,${message}",
        'command_values': message
      },
    );

    return ResultResponse.fromJson(responseMap);

  }

  Future<ResultResponse> sendCommand({
    required String token,
    required int id,
    required String commandCode,
    required String command,
  }) async {
    final Map<dynamic, dynamic> responseMap = await super.request(
      functionName: 'device/${id.toString()}/send',
      method: 'POST',
      token: token,
      body: {
        'command_code': commandCode,
        'command': command,
      },
    );

    return ResultResponse.fromJson(responseMap);

  }

  Future<ResultResponse> sendFlowers({
    required String token,
    required int id,
    required String flowers,
  }) async {
    final Map<dynamic, dynamic> responseMap = await super.request(
      functionName: 'device/${id.toString()}/send',
      method: 'POST',
      token: token,
      queryParameters: {
        'command_code': "send_flowers",
        'command': "FLOWER,${flowers}",
        'command_values': [int.parse(flowers)],
      },
    );

    return ResultResponse.fromJson(responseMap);

  }


  Future<ConnectionsDataResponse> connections({
    required String token,
    required int id,
  }) async {
    final Map<dynamic, dynamic> responseMap = await super.request(
      functionName: 'device/${id.toString()}/connections',
      method: 'GET',
      token: token,
    );

    return ConnectionsDataResponse.fromJson(responseMap);

  }

}
