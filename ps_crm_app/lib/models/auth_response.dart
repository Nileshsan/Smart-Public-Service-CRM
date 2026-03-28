import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  final bool success;
  final String? message;
  final UserData? data;
  final bool? pending;

  AuthResponse({
    required this.success,
    this.message,
    this.data,
    this.pending,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

@JsonSerializable()
class UserData {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? ward;
  final String? department;
  final String? token;

  UserData({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.ward,
    this.department,
    this.token,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
