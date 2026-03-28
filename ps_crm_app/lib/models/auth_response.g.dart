// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
  success: json['success'] as bool,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : UserData.fromJson(json['data'] as Map<String, dynamic>),
  pending: json['pending'] as bool?,
);

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'pending': instance.pending,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  id: json['_id'] as String?,
  name: json['name'] as String,
  email: json['email'] as String,
  role: json['role'] as String,
  phone: json['phone'] as String?,
  ward: json['ward'] as String?,
  department: json['department'] as String?,
  token: json['token'] as String?,
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'role': instance.role,
  'phone': instance.phone,
  'ward': instance.ward,
  'department': instance.department,
  'token': instance.token,
};
