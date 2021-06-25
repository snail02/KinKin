
class SosSms {
  String? type;

  SosSms({this.type});

  SosSms.fromJson(Map<String, dynamic> json) {
    type = json['type'];
  }


}
