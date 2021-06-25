import 'package:flutter_app/models/token/access_token.dart';

class User{
   int id;
   String name;
   String email;

  User(
      {required this.id,
        required this.name,
        required this.email,
  });

  factory User.fromJson(Map<dynamic, dynamic> json) {
      return User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
      );
  }

}