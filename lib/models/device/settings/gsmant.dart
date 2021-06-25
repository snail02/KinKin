class Gsmant {
  String? type;

  Gsmant({this.type});

  Gsmant.fromJson(Map<String, dynamic> json) {
    type = json['type'];
  }


}