import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:invennico_fbp/core/config/app_constants.dart';
import 'package:invennico_fbp/core/services/storage_helper.dart';

class DioService {
  late Dio _dio;
  String? _bearerToken;
  // final String baseUrl = 'https://reqres.in';

  void setBearerToken(String token) {
    _bearerToken = token;
  }

  Future<void> loadTokenFromStorage() async {
    final token = await StorageHelper.getToken();
    if (token != null) {
      setBearerToken(token);
    }
  }

  static header() => {
    "Content-Type": "application/json",

    // "Accept": "*/*",
    // "Access-Control-Allow-Origin": "*",
  };

  DioService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: '${AppConstant.baseUrl}${AppConstant.version}',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: header(),
      ),
    );
  }

  Future<dynamic> request(
    String method,
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Map<String, String>? extraHeaders,
  }) async {
    try {
      await loadTokenFromStorage();
      Response response = await _dio.request(
        endpoint,
        data: data,
        queryParameters: queryParams,
        options: Options(
          method: method,
          headers: {
            ...header(),
            if (_bearerToken != null) 'Authorization': 'Bearer $_bearerToken',
            if (extraHeaders != null) ...extraHeaders,
          },
        ),
      );
      if (data is FormData) {
        debugPrint('FormData fields:');
        for (var field in data.fields) {
          debugPrint('  ${field.key}: ${field.value}');
        }
        debugPrint(
          'URL: ${AppConstant.baseUrl}${AppConstant.version}$endpoint | Method: $method | Query Params: $queryParams',
        );
        debugPrint('Response Data: ${response.data}');
      } else {
        debugPrint(
          'URL: ${AppConstant.baseUrl}${AppConstant.version}$endpoint | Method: $method | Query Params: $queryParams ',
        );
        debugPrint('Response Data: ${response.data}');
      }
      return response.data;
    } on DioException catch (e) {
      debugPrint(
        'URL: ${AppConstant.baseUrl}${AppConstant.version}$endpoint | Method: $method | Query Params: $queryParams',
      );
      // print('Error Response: ${e.message}');
      return _handleDioError(e);
    } catch (e) {
      return {'error': 'Unexpected error: ${e.toString()}'};
    }
  }

  Map<String, dynamic> _handleDioError(DioException error) {
    debugPrint("RESPONSE DATA: ${error.response?.data}");
    debugPrint("RESPONSE STATUS CODE: ${error.response?.statusCode}");
    if (error.type == DioExceptionType.connectionError ||
        error.error.toString().contains('SocketException')) {
      return {
        'error': 'No internet connection',
        'message': 'Please check your network and try again',
      };
    }

    if (error.response != null) {
      final responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        return responseData;
      }

      return {
        'error': 'Unexpected error format',
        'message': responseData.toString(),
      };
    }

    // Keep fallback error messages for other types
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return {'error': 'Connection timeout'};
      case DioExceptionType.receiveTimeout:
        return {'error': 'Receive timeout'};
      case DioExceptionType.sendTimeout:
        return {'error': 'Send timeout'};
      case DioExceptionType.badResponse:
        return {
          'error': 'Bad response',
          'statusCode': error.response?.statusCode,
          'message': error.response?.statusMessage,
        };
      case DioExceptionType.cancel:
        return {'error': 'Request cancelled'};
      case DioExceptionType.connectionError:
        return {'error': 'No internet connection'};
      case DioExceptionType.unknown:
      default:
        return {'error': 'Something went wrong: ${error.message}'};
    }
  }
}

class ApiTypes {
  static String get = 'GET';
  static String post = 'POST';
  static String put = 'PUT';
  static String patch = 'PATCH';
  static String delete = 'DELETE';
}
