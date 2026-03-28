// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Feedback _$FeedbackFromJson(Map<String, dynamic> json) => Feedback(
  id: json['_id'] as String?,
  complaintId: json['complaintId'] as String?,
  rating: (json['rating'] as num?)?.toInt(),
  comment: json['comment'] as String?,
  submittedBy: json['submittedBy'] as String?,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$FeedbackToJson(Feedback instance) => <String, dynamic>{
  '_id': instance.id,
  'complaintId': instance.complaintId,
  'rating': instance.rating,
  'comment': instance.comment,
  'submittedBy': instance.submittedBy,
  'createdAt': instance.createdAt,
};
