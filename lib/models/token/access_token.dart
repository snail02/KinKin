
import 'package:flutter/material.dart';

class AccessToken{
  final String accessToken;

  AccessToken( {required this.accessToken,});

  factory AccessToken.fromJson(Map<dynamic, dynamic> json) {
    return AccessToken(
      accessToken: json['access_token'],
    );
  }

  factory AccessToken.create(String accessToken) {
    return AccessToken(
      accessToken: accessToken,
    );
  }


}