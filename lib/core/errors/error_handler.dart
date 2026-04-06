import 'package:dio/dio.dart';
import 'Failure.dart';

class ErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else {
      return const UnknownFailure("Unexpected error occurred");
    }
  }

  static Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return const TimeoutFailure("Connection timeout");

      case DioExceptionType.sendTimeout:
        return const TimeoutFailure("Send timeout");

      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure("Receive timeout");

      case DioExceptionType.badResponse:
        return _handleResponseError(error);

      case DioExceptionType.cancel:
        return const CancelFailure("Request was cancelled");

      case DioExceptionType.connectionError:
        return const NetworkFailure("No internet connection");

      case DioExceptionType.unknown:
        return const UnknownFailure("Something went wrong");
      case DioExceptionType.badCertificate:
        return const ServerFailure("Bad certificate");
    }
  }

  static Failure _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;

    switch (statusCode) {
      case 400:
        return const ServerFailure("Bad request", statusCode: 400);

      case 401:
        return const ServerFailure("Unauthorized", statusCode: 401);

      case 403:
        return const ServerFailure("Forbidden", statusCode: 403);

      case 404:
        return const ServerFailure("Not found", statusCode: 404);

      case 500:
        return const ServerFailure("Internal server error", statusCode: 500);

      default:
        return ServerFailure(
          error.response?.data?["message"] ?? "Server error",
          statusCode: statusCode,
        );
    }
  }
}
