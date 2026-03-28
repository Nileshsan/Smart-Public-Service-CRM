import 'package:json_annotation/json_annotation.dart';

part 'complaint.g.dart';

@JsonSerializable()
class Filer {
  @JsonKey(name: 'entryId')
  final String entryId;
  final CitizenInfo citizen;
  final String? description;
  final List<ComplaintImage>? images;
  @JsonKey(name: 'filedAt')
  final String? filedAt;

  Filer({
    required this.entryId,
    required this.citizen,
    this.description,
    this.images,
    this.filedAt,
  });

  factory Filer.fromJson(Map<String, dynamic> json) => _$FilerFromJson(json);
  Map<String, dynamic> toJson() => _$FilerToJson(this);
}

@JsonSerializable()
class CitizenInfo {
  final String name;
  final String email;
  final String? phone;

  CitizenInfo({
    required this.name,
    required this.email,
    this.phone,
  });

  factory CitizenInfo.fromJson(Map<String, dynamic> json) =>
      _$CitizenInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CitizenInfoToJson(this);
}

@JsonSerializable()
class ComplaintImage {
  final String? data; // Base64
  final String? name;
  final String? type;
  @JsonKey(name: 'uploadedAt')
  final String? uploadedAt;

  ComplaintImage({
    this.data,
    this.name,
    this.type,
    this.uploadedAt,
  });

  factory ComplaintImage.fromJson(Map<String, dynamic> json) =>
      _$ComplaintImageFromJson(json);
  Map<String, dynamic> toJson() => _$ComplaintImageToJson(this);
}

@JsonSerializable()
class SLAInfo {
  final String? deadline;
  bool? escalated;
  @JsonKey(name: 'escalatedAt')
  final String? escalatedAt;

  SLAInfo({
    this.deadline,
    this.escalated,
    this.escalatedAt,
  });

  factory SLAInfo.fromJson(Map<String, dynamic> json) =>
      _$SLAInfoFromJson(json);
  Map<String, dynamic> toJson() => _$SLAInfoToJson(this);
}

@JsonSerializable()
class Complaint {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'complaintNumber')
  final String? complaintNumber;
  final String title;
  final String? description;
  final String? category;
  final String? urgency;
  final String? department;
  final String? status;
  final String? resolution;
  final String? ward;
  final String? locality;
  final String? address;
  final List<Filer>? filers;
  final List<ComplaintImage>? images;
  final List<ComplaintImage>? afterImages;
  @JsonKey(name: 'assignedTo')
  final String? assignedTo;
  @JsonKey(name: 'assignedOfficerName')
  final String? assignedOfficerName;
  @JsonKey(name: 'duplicateKey')
  final String? duplicateKey;
  final SLAInfo? sla;
  @JsonKey(name: 'createdAt')
  final String? createdAt;
  @JsonKey(name: 'updatedAt')
  final String? updatedAt;

  Complaint({
    this.id,
    this.complaintNumber,
    required this.title,
    this.description,
    this.category,
    this.urgency,
    this.department,
    this.status,
    this.resolution,
    this.ward,
    this.locality,
    this.address,
    this.filers,
    this.images,
    this.afterImages,
    this.assignedTo,
    this.assignedOfficerName,
    this.duplicateKey,
    this.sla,
    this.createdAt,
    this.updatedAt,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) =>
      _$ComplaintFromJson(json);
  Map<String, dynamic> toJson() => _$ComplaintToJson(this);

  @override
  String toString() =>
      'Complaint(id: $id, number: $complaintNumber, title: $title, status: $status)';
}
