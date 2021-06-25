class PhoneBook {
  String? type;

  PhoneBook({this.type});

  PhoneBook.fromJson(Map<String, dynamic> json) {
    type = json['type'];
  }


}