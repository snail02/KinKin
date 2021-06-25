
import 'package:flutter_app/models/token/access_token.dart';
import 'package:flutter_app/models/user/user.dart';

class AuthDataResponse{
  final User user;
  final AccessToken accessToken;

  AuthDataResponse(
      {required this.user,
        required this.accessToken,
      });

  factory AuthDataResponse.fromJson(Map<dynamic, dynamic> json) {
    return AuthDataResponse(
      user: User.fromJson(json['user']),
      accessToken: AccessToken.create(json['access_token']),
    );
  }
}