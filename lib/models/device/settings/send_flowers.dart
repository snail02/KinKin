 class SendFlowers {
  String? type;
  String? value;
  String? sentValue;

  SendFlowers({this.type, this.value, this.sentValue});

  SendFlowers.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
    sentValue = json['sent_value'];
  }

}