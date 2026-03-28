// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => ApiResponse<T>(
  success: json['success'] as bool,
  message: json['message'] as String?,
  data: _$nullableGenericFromJson(json['data'], fromJsonT),
  isDuplicate: json['isDuplicate'] as bool?,
  similarityScore: (json['similarityScore'] as num?)?.toDouble(),
);

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': _$nullableGenericToJson(instance.data, toJsonT),
  'isDuplicate': instance.isDuplicate,
  'similarityScore': instance.similarityScore,
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);

ClassificationResult _$ClassificationResultFromJson(
  Map<String, dynamic> json,
) => ClassificationResult(
  category: json['category'] as String,
  urgency: json['urgency'] as String,
  department: json['department'] as String,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$ClassificationResultToJson(
  ClassificationResult instance,
) => <String, dynamic>{
  'category': instance.category,
  'urgency': instance.urgency,
  'department': instance.department,
  'reason': instance.reason,
};
