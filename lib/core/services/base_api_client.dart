import 'dart:developer';
import 'package:dio/dio.dart';
import 'api_routes.dart';

class BaseApiClient {
  final Dio _dio;

  BaseApiClient({String? baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl ?? ApiRoutes.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          contentType: 'application/json',
          headers: {'Accept': 'application/json'},
          validateStatus: (status) =>
              status != null && status >= 200 && status < 300,
        ),
      ) {
    // Logging Interceptor
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
        error: true,
        logPrint: (object) => log(object.toString()),
      ),
    );
  }

  Dio get dio => _dio;

  Future<String> handleError(DioException error) async {
    log('API Error: ${error.type}');
    log('Error message: ${error.message}');
    log('Response data: ${error.response?.data}');

    if (error.response != null) {
      final data = error.response!.data;
      final message = data is Map ? (data['message'] ?? data['error']) : null;

      switch (error.response!.statusCode) {
        case 400:
          return message?.toString() ?? 'Bad request';
        case 401:
          return message?.toString() ?? 'Unauthorized: Please check your credentials';
        case 403:
          return message?.toString() ?? 'Forbidden: Access denied';
        case 404:
          return message?.toString() ?? 'Not found: The requested resource was not found';
        case 422:
          return message?.toString() ?? 'Validation error';
        case 500:
          return 'Server error: Please try again later';
        default:
          return message?.toString() ?? 'Unknown error occurred';
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout: Please check your internet connection';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout: Server is taking too long to respond';
      case DioExceptionType.sendTimeout:
        return 'Send timeout: Failed to send data to server';
      case DioExceptionType.badResponse:
        return 'Bad response from server';
      case DioExceptionType.cancel:
        return 'Request was cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error: Please check your internet connection and server status';
      case DioExceptionType.unknown:
        return 'Unknown error: ${error.message}';
      default:
        return error.message ?? 'Unknown error occurred';
    }
  }
}
