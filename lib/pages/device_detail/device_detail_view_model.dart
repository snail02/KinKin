import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter_app/api/result_response.dart';
import 'package:flutter_app/models/device/settings/settings.dart';
import 'package:flutter_app/models/event/event.dart';
import 'package:flutter_app/pages/device_detail/events_data_response.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:flutter_app/utils/text_command.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as image;

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/device_api.dart';
import 'package:flutter_app/api/exceptions/dio_exceptions.dart';
import 'package:flutter_app/models/device/commands.dart';
import 'package:flutter_app/models/device/device_detail.dart';
import 'package:flutter_app/pages/device_detail/device_detail_data_response.dart';
import 'package:flutter_app/pages/device_detail/device_detail_events.dart';
import 'package:flutter_app/pages/device_detail/device_detail_states.dart';
import 'package:flutter_app/pages/device_detail/device_detail_view.dart';
import 'package:flutter_app/utils/common_ui/common_notification.dart';
import 'package:flutter_app/utils/url_image.dart';
import 'package:flutter_app/utils/view_model/view_model.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class DeviceDetailViewModel
    extends ViewModel<DeviceDetailView, DeviceDetailState, DeviceDetailEvent> {
  final DeviceApi _devicesApi = DeviceApi();

  // List <Device> list;

  DeviceDetailDataResponse? deviceDetailDataResponse;
  DeviceDetail? deviceDetail;
  List<Commands>? commands;
  Settings? settings;
  List<Event> events = <Event>[];

  Uint8List? bitImage;
  Response? response;

  bool permission = false;

  DeviceDetailViewModel({required DeviceDetailView view}) : super(view: view);

  final Map<Field, String> _fieldErrors = {};

  void _addIdleState() {
    statesStreamController.add(
      Idle(
        errors: _fieldErrors,
      ),
    );
  }

  Future<void> updateDeviceDetail({required int id}) async {
    if (deviceDetail == null)
      statesStreamController.add(UpdateDeviceDetailInProgress());

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('accessToken') != null) {
      String accessToken = prefs.get('accessToken').toString();

      await _devicesApi
          .deviceDetail(id: id, token: accessToken)
          .then((deviceDetailDataResponse) {
        _onSuccessUpdateDeviceDetailToApi(
            deviceDetailDataResponse: deviceDetailDataResponse);
      }).catchError((e) async {
        if (e is DioExceptions) {
          //_addIdleState();
          _showNotificationError(e.message);
        }
      });

      await _devicesApi
          .events(token: accessToken, id: id, limit: 5)
          .then((eventsDataResponse) {
        _onSuccessUpdateEventsToApi(eventsDataResponse: eventsDataResponse);
      }).catchError((e) async {
        if (e is DioExceptions) {
          //_addIdleState();
          _showNotificationError(e.message);
        }
      });
      _addIdleState();
    }
  }

  void _onSuccessUpdateEventsToApi(
      {EventsDataResponse? eventsDataResponse}) async {
    if (eventsDataResponse != null) {
      if (eventsDataResponse.result == 'success') {
        events = eventsDataResponse.events!;
      } else {
        _showNotificationError('result: Error');
      }
    } else {
      _showNotificationError('Не удалось получить данные');
    }
    print("data load success");
    _addIdleState();
  }

  void _onSuccessUpdateDeviceDetailToApi(
      {DeviceDetailDataResponse? deviceDetailDataResponse}) async {
    if (deviceDetailDataResponse != null) {
      if (deviceDetailDataResponse.result == 'success') {
        deviceDetail = deviceDetailDataResponse.deviceDetail!;
        bitImage =
            await getMarkerIcon(url: UrlImage().url(deviceDetail!.image ?? ""));
        commands = deviceDetailDataResponse.commands;
        settings = deviceDetailDataResponse.settings;
      } else {
        _showNotificationError('result: Error');
      }
    } else {
      _showNotificationError('Не удалось получить данные');
    }
    print("data load success");
    _addIdleState();
  }

  Future<void> uploadVoiceMessage(
      {required int id,
      required String fileName,
      required String filePath,
      required String type,
      required String ext}) async {
    statesStreamController.add(SendingDataInProgress());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('accessToken') != null) {
      String accessToken = prefs.get('accessToken').toString();

      await _devicesApi
          .sendVoiceMessage(
              token: accessToken,
              id: id,
              fileName: fileName,
              filePath: filePath,
              type: type,
              ext: ext)
          .then((resultResponse) {
        _onSuccessSendVoiceMessageToApi(resultResponse: resultResponse);
      }).catchError((e) async {
        if (e is DioExceptions) {
          //_addIdleState();
          _showNotificationError(e.message);
        }
      });
    }
    _addIdleState();
  }

  void _onSuccessSendVoiceMessageToApi({ResultResponse? resultResponse}) async {
    if (resultResponse != null) {
      if (resultResponse.result == 'success') {
        view.showNotificationBanner(
          CommonUiNotification(
              type: CommonUiNotificationType.SENTCOMMAND,
              message: LocaleKeys.all_done.tr() +
                  '\n' +
                  TextCommand().getText("voice_message") +
                  " completed"),
        );
      } else {
        _showNotificationError('result: Error');
      }
    } else {
      _showNotificationError('Не удалось получить данные');
    }
    print("data load success");
  }

  void _onSuccessSendCommandToApi(
      {ResultResponse? resultResponse, String? commandCode}) async {
    if (resultResponse != null) {
      if (resultResponse.result == 'new') {
        view.showNotificationBanner(
          CommonUiNotification(
              type: CommonUiNotificationType.SENTCOMMAND,
              message: LocaleKeys.all_done.tr() +
                  '\n' +
                  TextCommand().getText(commandCode ?? "") +
                  " completed"),
        );
      } else {
        _showNotificationError('result: Error');
      }
    } else {
      _showNotificationError('Не удалось получить данные');
    }
    print("data load success");
  }

  Future<void> sendCommand(
      {required int id,
      required String commandCode,
      required String command}) async {
    statesStreamController.add(SendingDataInProgress());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('accessToken') != null) {
      String accessToken = prefs.get('accessToken').toString();

      await _devicesApi
          .sendCommand(
        token: accessToken,
        id: id,
        commandCode: commandCode,
        command: command,
      )
          .then((resultResponse) {
        _onSuccessSendCommandToApi(
            resultResponse: resultResponse, commandCode: commandCode);
      }).catchError((e) async {
        if (e is DioExceptions) {
          //_addIdleState();
          _showNotificationError(e.message);
        }
      });
    }
    _addIdleState();
  }

  Future<bool> sendTextMessage(
      {required int id, required String message}) async {
    bool result = false;
    statesStreamController.add(SendingDataInProgress());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('accessToken') != null) {
      String accessToken = prefs.get('accessToken').toString();

      await _devicesApi
          .sendTextMessage(
        token: accessToken,
        id: id,
        message: message,
      )
          .then((resultResponse) {
        _onSuccessSendTextMessageToApi(resultResponse: resultResponse);
        result = true;
      }).catchError((e) async {
        if (e is DioExceptions) {
          //_addIdleState();
          _showNotificationError(e.message);
        }
        result = false;
      });
    }
    _addIdleState();
    return result;
  }

  bool haveVoiceMessageCommands() {
    bool result = false;
    if (commands == null) return false;
    commands!.forEach((element) {
      if (element.code == "voice_message")
        result = true;
    });
    return result;
  }

  void _onSuccessSendTextMessageToApi({ResultResponse? resultResponse}) async {
    if (resultResponse != null) {
      if (resultResponse.result == 'success') {
        view.showNotificationBanner(
          CommonUiNotification(
              type: CommonUiNotificationType.SENTCOMMAND,
              message: LocaleKeys.all_done.tr() +
                  '\n' +
                  TextCommand().getText("send_message") +
                  " completed"),
        );
      } else {
        _showNotificationError('result: Error');
      }
    } else {
      _showNotificationError('Не удалось получить данные');
    }
    print("data load success");
  }

  Future<void> sendFlowers({required int id, required String flowers}) async {
    statesStreamController.add(SendingDataInProgress());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.get('accessToken') != null) {
      String accessToken = prefs.get('accessToken').toString();

      await _devicesApi
          .sendFlowers(
        token: accessToken,
        id: id,
        flowers: flowers,
      )
          .then((resultResponse) {
        _onSuccessSendFlowersToApi(resultResponse: resultResponse);
      }).catchError((e) async {
        if (e is DioExceptions) {
          //_addIdleState();
          _showNotificationError(e.message);
        }
      });
    }
    _addIdleState();
  }

  void _onSuccessSendFlowersToApi({ResultResponse? resultResponse}) async {
    if (resultResponse != null) {
      if (resultResponse.result == 'new') {
        view.showNotificationBanner(
          CommonUiNotification(
              type: CommonUiNotificationType.SENTCOMMAND,
              message: LocaleKeys.all_done.tr() +
                  '\n' +
                  TextCommand().getText("send_flowers") +
                  " completed"),
        );
      } else {
        _showNotificationError('result: Error');
      }
    } else {
      _showNotificationError('Не удалось получить данные');
    }
    print("data load success");
  }

  void _showNotificationError(String message) {
    view.showNotificationBanner(
      CommonUiNotification(
        type: CommonUiNotificationType.ERROR,
        message: message,
      ),
    );
  }

  // List<Event> getSortEvents() {
  //   List<Event> sortEvents = events;
  //   sortEvents.sort((a, b) => a.datentime.compareTo(b.datentime));
  //
  //   return sortEvents;
  // }

  Future<ui.Image> getImage(String path) async {
    var markerImageFile = await DefaultCacheManager().getSingleFile(path);
    var markerImageByte = await markerImageFile.readAsBytes();
    var markerImageCodec = await instantiateImageCodec(
      markerImageByte,
      targetWidth: 140,
      targetHeight: 140,
    );
    var frameInfo = await markerImageCodec.getNextFrame();
    var byteData = await frameInfo.image.toByteData(
      format: ImageByteFormat.png,
    );
    var resizedMarkerImageBytes = byteData!.buffer.asUint8List();

    ui.Codec codec = await ui.instantiateImageCodec(resizedMarkerImageBytes);
    ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
  }

  Future<ui.Image> getUiImage(
      String imageAssetPath, int height, int width) async {
    final ByteData assetImageByteData = await rootBundle.load(imageAssetPath);
    image.Image baseSizeImage =
        image.decodeImage(assetImageByteData.buffer.asUint8List())!;
    image.Image resizeImage =
        image.copyResize(baseSizeImage, height: height, width: width);
    ui.Codec codec = await ui
        .instantiateImageCodec(image.encodePng(resizeImage) as Uint8List);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  Future<Uint8List> getMarkerIcon({required String url}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Color.fromRGBO(238, 238, 238, 1);

    ui.Image image = await getUiImage('assets/images/marker.png', 250, 200);
    canvas.drawImage(image, Offset(0.0, 0.0), paint);

    ui.Image image2 = await getImage(url);
    canvas.drawImage(image2, new Offset(30.0, 22.0), paint);

    final img = await pictureRecorder.endRecording().toImage(200, 250);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  Future<void> checkPermission() async {
    var microphoneStatus = await Permission.microphone.status;
    var storageStatus = await Permission.storage.status;

    if (microphoneStatus.isGranted && storageStatus.isGranted)
      permission = true;
    else
      permission = false;
  }

  Future<void> askPermission() async {
    await Permission.microphone.request();
    await Permission.storage.request();
    await checkPermission();

  }

  List<Commands>? getAvailableCommands() {
    if (commands != null) {
      List<Commands> availableCommands = [];
      commands!.forEach((element) {
        if (element.command != null && element.code != "send_message")
          availableCommands.add(element);
      });
      return availableCommands;
    } else
      return null;
  }

}
