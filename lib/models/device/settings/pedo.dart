class Pedo {
  String? type;

  Pedo({this.type});

  Pedo.fromJson(Map<String, dynamic> json) {
    type = json['type'];
  }


}