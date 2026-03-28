// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Filer _$FilerFromJson(Map<String, dynamic> json) => Filer(
  entryId: json['entryId'] as String,
  citizen: CitizenInfo.fromJson(json['citizen'] as Map<String, dynamic>),
  description: json['description'] as String?,
  images: (json['images'] as List<dynamic>?)
      ?.map((e) => ComplaintImage.fromJson(e as Map<String, dynamic>))
      .toList(),
  filedAt: json['filedAt'] as String?,
);

Map<String, dynamic> _$FilerToJson(Filer instance) => <String, dynamic>{
  'entryId': instance.entryId,
  'citizen': instance.citizen,
  'description': instance.description,
  'images': instance.images,
  'filedAt': instance.filedAt,
};

CitizenInfo _$CitizenInfoFromJson(Map<String, dynamic> json) => CitizenInfo(
  name: json['name'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String?,
);

Map<String, dynamic> _$CitizenInfoToJson(CitizenInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
    };

ComplaintImage _$ComplaintImageFromJson(Map<String, dynamic> json) =>
    ComplaintImage(
      data: json['data'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      uploadedAt: json['uploadedAt'] as String?,
    );

Map<String, dynamic> _$ComplaintImageToJson(ComplaintImage instance) =>
    <String, dynamic>{
      'data': instance.data,
      'name': instance.name,
      'type': instance.type,
      'uploadedAt': instance.uploadedAt,
    };

SLAInfo _$SLAInfoFromJson(Map<String, dynamic> json) => SLAInfo(
  deadline: json['deadline'] as String?,
  escalated: json['escalated'] as bool?,
  escalatedAt: json['escalatedAt'] as String?,
);

Map<String, dynamic> _$SLAInfoToJson(SLAInfo instance) => <String, dynamic>{
  'deadline': instance.deadline,
  'escalated': instance.escalated,
  'escalatedAt': instance.escalatedAt,
};

Complaint _$ComplaintFromJson(Map<String, dynamic> json) => Complaint(
  id: json['_id'] as String?,
  complaintNumber: json['complaintNumber'] as String?,
  title: json['title'] as String,
  description: json['description'] as String?,
  category: json['category'] as String?,
  urgency: json['urgency'] as String?,
  department: json['department'] as String?,
  status: json['status'] as String?,
  resolution: json['resolution'] as String?,
  ward: json['ward'] as String?,
  locality: json['locality'] as String?,
  address: json['address'] as String?,
  filers: (json['filers'] as List<dynamic>?)
      ?.map((e) => Filer.fromJson(e as Map<String, dynamic>))
      .toList(),
  images: (json['images'] as List<dynamic>?)
      ?.map((e) => ComplaintImage.fromJson(e as Map<String, dynamic>))
      .toList(),
  afterImages: (json['afterImages'] as List<dynamic>?)
      ?.map((e) => ComplaintImage.fromJson(e as Map<String, dynamic>))
      .toList(),
  assignedTo: json['assignedTo'] as String?,
  assignedOfficerName: json['assignedOfficerName'] as String?,
  duplicateKey: json['duplicateKey'] as String?,
  sla: json['sla'] == null
      ? null
      : SLAInfo.fromJson(json['sla'] as Map<String, dynamic>),
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$ComplaintToJson(Complaint instance) => <String, dynamic>{
  '_id': instance.id,
  'complaintNumber': instance.complaintNumber,
  'title': instance.title,
  'description': instance.description,
  'category': instance.category,
  'urgency': instance.urgency,
  'department': instance.department,
  'status': instance.status,
  'resolution': instance.resolution,
  'ward': instance.ward,
  'locality': instance.locality,
  'address': instance.address,
  'filers': instance.filers,
  'images': instance.images,
  'afterImages': instance.afterImages,
  'assignedTo': instance.assignedTo,
  'assignedOfficerName': instance.assignedOfficerName,
  'duplicateKey': instance.duplicateKey,
  'sla': instance.sla,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
