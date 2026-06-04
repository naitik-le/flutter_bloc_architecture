import 'package:flutter_bloc_architecture/core/network/api_status.dart';

/// Generic API response wrapper.
///
/// Standardizes how API responses are parsed and consumed throughout
/// the data layer, supporting both success and error states.
class ApiResponse<T> {
  /// The status of the API request (success or error).
  final ApiStatus status;

  /// The parsed response data.
  final T? data;

  /// Error message, if any.
  final String? errorMsg;

  /// HTTP status code.
  final int? statusCode;

  /// Creates an [ApiResponse].
  const ApiResponse({
    required this.status,
    this.data,
    this.errorMsg,
    this.statusCode,
  });

  /// Creates a successful response.
  factory ApiResponse.success({
    ApiStatus status = ApiStatus.success,
    T? data,
    int? statusCode,
    String? errorMsg = '',
  }) {
    return ApiResponse<T>(
      status: status,
      data: data,
      statusCode: statusCode,
      errorMsg: errorMsg,
    );
  }

  /// Creates an error response.
  factory ApiResponse.error({
    ApiStatus status = ApiStatus.error,
    String? errorMsg,
    int? statusCode,
    T? data,
  }) {
    return ApiResponse<T>(
      status: status,
      errorMsg: errorMsg,
      statusCode: statusCode,
      data: data,
    );
  }

  /// Creates an [ApiResponse] from a raw JSON [Map].
  ///
  /// The [fromJsonT] callback parses the `data` field into type [T].
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    final bool isSuccess = json['success'] as bool? ?? true;
    return ApiResponse<T>(
      status: isSuccess ? ApiStatus.success : ApiStatus.error,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errorMsg: json['message'] as String?,
      statusCode: json['statusCode'] as int?,
    );
  }
}
