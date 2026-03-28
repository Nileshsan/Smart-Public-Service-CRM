import 'package:dio/dio.dart';
import 'package:ps_crm_app/utils/constants.dart';
import 'package:ps_crm_app/utils/storage_service.dart';
import '../models/api_response.dart';
import '../models/complaint.dart';
import '../models/auth_response.dart';

class ApiService {
  late Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
        receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptor for auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = StorageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Handle errors globally
          return handler.next(e);
        },
      ),
    );
  }

  // Auth endpoints
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phone,
    String? ward,
    String? department,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.authRegister,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'role': role,
          if (phone != null) 'phone': phone,
          if (ward != null) 'ward': ward,
          if (department != null) 'department': department,
        },
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.authLogin,
        data: {
          'email': email,
          'password': password,
        },
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Complaint endpoints
  Future<ApiResponse<Complaint>> submitComplaint({
    required String title,
    required String category,
    String? description,
    required String urgency,
    required String ward,
    required String locality,
    required String address,
    required String name,
    required String email,
    String? phone,
    List<Map<String, dynamic>>? images,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.complaintsSubmit,
        data: {
          'title': title,
          'description': description,
          'category': category,
          'urgency': urgency,
          if (images != null && images.isNotEmpty) 'images': images,
          'location': {
            'ward': ward,
            'locality': locality,
            'address': address,
          },
          'citizen': {
            'name': name,
            'email': email,
            'phone': phone,
          },
        },
      );
      return _parseApiResponse<Complaint>(
        response.data,
        (json) => Complaint.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Complaint>> getMyComplaints() async {
    try {
      final response = await _dio.get(AppConstants.complaintsGetMy);
      final apiResponse = ApiResponse<List<Complaint>>.fromJson(
        response.data,
        (json) {
          if (json is List) {
            return json
                .map((e) => Complaint.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          return [];
        },
      );
      return apiResponse.data ?? [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Complaint?> trackComplaint({
    required String complaintNumber,
    required String email,
  }) async {
    try {
      final response = await _dio.get(
        '${AppConstants.complaintsTrack}/$complaintNumber',
        queryParameters: {'email': email},
      );
      final apiResponse = ApiResponse<Complaint>.fromJson(
        response.data,
        (json) => Complaint.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Complaint>> getAllComplaints() async {
    try {
      final response = await _dio.get(AppConstants.complaintsGetAll);
      final apiResponse = ApiResponse<List<Complaint>>.fromJson(
        response.data,
        (json) {
          if (json is List) {
            return json
                .map((e) => Complaint.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          return [];
        },
      );
      return apiResponse.data ?? [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Complaint>> getAssignedComplaints() async {
    try {
      final response = await _dio.get(AppConstants.complaintsGetAssigned);
      final apiResponse = ApiResponse<List<Complaint>>.fromJson(
        response.data,
        (json) {
          if (json is List) {
            return json
                .map((e) => Complaint.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          return [];
        },
      );
      return apiResponse.data ?? [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Complaint> updateComplaintStatus({
    required String id,
    required String status,
    String? resolution,
  }) async {
    try {
      final response = await _dio.put(
        '${AppConstants.complaintsSubmit}/$id',
        data: {
          'status': status,
          if (resolution != null) 'resolution': resolution,
        },
      );
      final apiResponse = ApiResponse<Complaint>.fromJson(
        response.data,
        (json) => Complaint.fromJson(json as Map<String, dynamic>),
      );
      return apiResponse.data!;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<ApiResponse<dynamic>> classifyComplaint({
    required String title,
    required String description,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.complaintsClassify,
        data: {
          'title': title,
          'description': description,
        },
      );
      return ApiResponse.fromJson(
        response.data,
        (json) => json,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Feedback endpoints
  Future<ApiResponse<dynamic>> submitFeedback({
    required String complaintId,
    required int rating,
    required String comment,
    required String submittedBy,
  }) async {
    try {
      final response = await _dio.post(
        AppConstants.feedbackSubmit,
        data: {
          'complaintId': complaintId,
          'rating': rating,
          'comment': comment,
          'submittedBy': submittedBy,
        },
      );
      return ApiResponse.fromJson(response.data, (json) => json);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Dashboard endpoints
  Future<Map<String, dynamic>> getPublicDashboard() async {
    try {
      final response = await _dio.get(AppConstants.dashboardPublic);
      return response.data['data'] ?? {};
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling
  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please try again.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Please try again.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'An error occurred';
        return '$message (Error: $statusCode)';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      case DioExceptionType.unknown:
        return 'An unexpected error occurred.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }

  ApiResponse<T> _parseApiResponse<T>(
    dynamic responseData,
    T Function(dynamic) fromJson,
  ) {
    if (responseData is Map<String, dynamic>) {
      return ApiResponse<T>.fromJson(responseData, (json) => fromJson(json));
    }
    throw Exception('Invalid response format');
  }
}
