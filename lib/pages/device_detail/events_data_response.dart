import 'package:flutter_app/models/event/event.dart';

class EventsDataResponse {
  String? result;
  List<Event>? events;

  EventsDataResponse({this.result, this.events, });

  EventsDataResponse.fromJson(Map<dynamic, dynamic> json) {
    result = json['result'];
    if (json['list'] != null) {
      events = <Event>[];
      json['list'].forEach((v) {
        events!.add(new Event.fromJson(v));
      });
    }
  }

}