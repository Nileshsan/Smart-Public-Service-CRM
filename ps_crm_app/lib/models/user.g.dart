// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['_id'] as String?,
  name: json['name'] as String,
  email: json['email'] as String,
  role: json['role'] as String,
  phone: json['phone'] as String?,
  ward: json['ward'] as String?,
  department: json['department'] as String?,
  status: json['status'] as String?,
  rejectionReason: json['rejectionReason'] as String?,
  token: json['token'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'role': instance.role,
  'phone': instance.phone,
  'ward': instance.ward,
  'department': instance.department,
  'status': instance.status,
  'rejectionReason': instance.rejectionReason,
  'token': instance.token,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
