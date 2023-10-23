import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class JwtModel {
  String? token;

  JwtModel({required this.token});

  String? get getToken => token;
}
