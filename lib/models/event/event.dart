import 'package:intl/intl.dart';
class Event {
  int id;
  String trackerUid;
  String datentime;
  String type;
  String? data;
  int? duration;
  DateTime? dateTime;

  Event({
    required this.id,
    required this.trackerUid,
    required this.datentime,
    required this.type,
    this.data,
    this.duration,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        id: json['id'],
        trackerUid: json['tracker_uid'],
        datentime: json['datentime'],
        type: json['type'],
        data: json['data'],
        duration: json['duration']);
  }

  DateTime getDateTime(){
    return DateTime.parse(datentime);
  }

  String getLastUpdateTime(String lang){

    var parsedDate = DateTime.parse(datentime);
    var formatDate = DateFormat('d MMM yyyy\nkk:mm', lang);
    var dateString = formatDate.format(parsedDate);

    return dateString;

  }

}
