import 'package:flutter/foundation.dart';


class UserLoginModel {
  final String userName;
  final String password;
  final String clientId;
  final String clientSecret;
  final String scope;

  UserLoginModel({
      @required this.userName,
      @required this.password,
      @required this.clientId,
      @required this.clientSecret,
      @required this.scope
      });

  factory  UserLoginModel.fromjson(Map<String, dynamic> json) {
    return UserLoginModel(
        userName: json['userName'] as String,
        password: json['password'] as String,
        clientId: json['clientId'] as String,
        clientSecret: json['clientSecret'] as String,
        scope: json['scope'] as String);
  }
}


