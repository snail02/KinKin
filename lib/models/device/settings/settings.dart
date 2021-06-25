import 'package:flutter_app/models/device/settings/gsmant.dart';
import 'package:flutter_app/models/device/settings/pedo.dart';
import 'package:flutter_app/models/device/settings/send_flowers.dart';
import 'package:flutter_app/models/device/settings/sos_sms.dart';

class Settings {
  SosSms? sosSms;
  Pedo? pedo;
  Gsmant? gsmant;
  SendFlowers? sendFlowers;

  Settings({this.sosSms, this.gsmant, this.pedo, this.sendFlowers});

  Settings.fromJson(Map<String, dynamic> json) {
    sosSms = json['sos_sms'] != null ?  SosSms.fromJson(json['sos_sms']) : null;
    gsmant = json['gsmant'] != null ?  Gsmant.fromJson(json['gsmant']) : null;
    pedo = json['pedo'] != null ?  Pedo.fromJson(json['pedo']) : null;
    sendFlowers = json['send_flowers'] != null
        ? SendFlowers.fromJson(json['send_flowers'])
        : null;
  }


}