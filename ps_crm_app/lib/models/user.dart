import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: '_id')
  final String? id;
  final String name;
  final String email;
  final String role; // citizen, officer, admin
  final String? phone;
  final String? ward;
  final String? department; // for officers
  final String? status; // active, pending, rejected (for officers)
  final String? rejectionReason;
  final String? token;
  @JsonKey(name: 'createdAt')
  final String? createdAt;
  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.ward,
    this.department,
    this.status,
    this.rejectionReason,
    this.token,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() => 'User(id: $id, name: $name, email: $email, role: $role)';
}
