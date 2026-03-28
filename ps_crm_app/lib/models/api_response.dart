import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  bool? isDuplicate;
  double? similarityScore;

  ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.isDuplicate,
    this.similarityScore,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}

@JsonSerializable()
class ClassificationResult {
  final String category;
  final String urgency;
  final String department;
  final String? reason;

  ClassificationResult({
    required this.category,
    required this.urgency,
    required this.department,
    this.reason,
  });

  factory ClassificationResult.fromJson(Map<String, dynamic> json) =>
      _$ClassificationResultFromJson(json);
  Map<String, dynamic> toJson() => _$ClassificationResultToJson(this);
}
