import 'package:intl/intl.dart';
class LastLocation {
  late double? lat;
  late double? lon;
  late int? spe;
  late String? dir;
  late String? alt;
  late int? sat;
  late String? dnt;
  late String? state;

  LastLocation(
      {required this.lat,
        required this.lon,
        required this.spe,
        required this.dir,
        required this.alt,
        required this.sat,
        required this.dnt,
        required this.state});

  LastLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
    spe = json['spe'];
    dir = json['dir'];
    alt = json['alt'];
    sat = json['sat'];
    dnt = json['dnt'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['spe'] = this.spe;
    data['dir'] = this.dir;
    data['alt'] = this.alt;
    data['sat'] = this.sat;
    data['dnt'] = this.dnt;
    data['state'] = this.state;
    return data;
  }

  String getLastUpdateTime(String lang){

    var parsedDate = DateTime.parse(dnt!);
    var formatDate = DateFormat('d MMM yyyy, kk:mm', lang);
    var dateString = formatDate.format(parsedDate);

    return dateString;

  }

}