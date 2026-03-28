import 'package:json_annotation/json_annotation.dart';

part 'feedback.g.dart';

@JsonSerializable()
class Feedback {
  @JsonKey(name: '_id')
  final String? id;
  @JsonKey(name: 'complaintId')
  final String? complaintId;
  final int? rating;
  final String? comment;
  @JsonKey(name: 'submittedBy')
  final String? submittedBy;
  @JsonKey(name: 'createdAt')
  final String? createdAt;

  Feedback({
    this.id,
    this.complaintId,
    this.rating,
    this.comment,
    this.submittedBy,
    this.createdAt,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) =>
      _$FeedbackFromJson(json);
  Map<String, dynamic> toJson() => _$FeedbackToJson(this);

  @override
  String toString() =>
      'Feedback(id: $id, complaintId: $complaintId, rating: $rating)';
}
