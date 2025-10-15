import 'package:get/get_connect/connect.dart';
import 'package:proximaride_app/utils/api_logger.dart';

class LoggedGetConnect extends GetConnect {
  LoggedGetConnect({Duration? timeout}) : super(timeout: timeout ?? const Duration(seconds: 120));

  @override
  Future<Response<T>> get<T>(String url,
      {Map<String, String>? headers,
      String? contentType,
      Map<String, dynamic>? query,
      Decoder<T>? decoder}) async {
    
    // Log the GET request
    final fullUrl = query != null && query.isNotEmpty 
        ? '$url?${query.entries.map((e) => '${e.key}=${e.value}').join('&')}'
        : url;
    ApiLogger.logGetRequest(fullUrl, headers);

    try {
      final response = await super.get<T>(
        url,
        headers: headers,
        contentType: contentType,
        query: query,
        decoder: decoder,
      );

      // Log the response
      ApiLogger.logResponse(fullUrl, response.statusCode ?? 0, response.body);

      return response;
    } catch (e) {
      ApiLogger.logError(fullUrl, e.toString());
      rethrow;
    }
  }

  @override
  Future<Response<T>> post<T>(String? url, dynamic body,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query,
      Decoder<T>? decoder,
      Progress? uploadProgress}) async {
    
    // Log the POST request
    final fullUrl = query != null && query.isNotEmpty 
        ? '$url?${query.entries.map((e) => '${e.key}=${e.value}').join('&')}'
        : url ?? '';
    ApiLogger.logPostRequest(fullUrl, body, headers);

    try {
      final response = await super.post<T>(
        url,
        body,
        contentType: contentType,
        headers: headers,
        query: query,
        decoder: decoder,
        uploadProgress: uploadProgress,
      );

      // Log the response
      ApiLogger.logResponse(fullUrl, response.statusCode ?? 0, response.body);

      return response;
    } catch (e) {
      ApiLogger.logError(fullUrl, e.toString());
      rethrow;
    }
  }

  @override
  Future<Response<T>> put<T>(String url, dynamic body,
      {String? contentType,
      Map<String, String>? headers,
      Map<String, dynamic>? query,
      Decoder<T>? decoder,
      Progress? uploadProgress}) async {
    
    // Log the PUT request
    final fullUrl = query != null && query.isNotEmpty 
        ? '$url?${query.entries.map((e) => '${e.key}=${e.value}').join('&')}'
        : url;
    ApiLogger.logPutRequest(fullUrl, body, headers);

    try {
      final response = await super.put<T>(
        url,
        body,
        contentType: contentType,
        headers: headers,
        query: query,
        decoder: decoder,
        uploadProgress: uploadProgress,
      );

      // Log the response
      ApiLogger.logResponse(fullUrl, response.statusCode ?? 0, response.body);

      return response;
    } catch (e) {
      ApiLogger.logError(fullUrl, e.toString());
      rethrow;
    }
  }

  @override
  Future<Response<T>> delete<T>(String url,
      {Map<String, String>? headers,
      String? contentType,
      Map<String, dynamic>? query,
      Decoder<T>? decoder}) async {
    
    // Log the DELETE request
    final fullUrl = query != null && query.isNotEmpty 
        ? '$url?${query.entries.map((e) => '${e.key}=${e.value}').join('&')}'
        : url;
    ApiLogger.logDeleteRequest(fullUrl, headers);

    try {
      final response = await super.delete<T>(
        url,
        headers: headers,
        contentType: contentType,
        query: query,
        decoder: decoder,
      );

      // Log the response
      ApiLogger.logResponse(fullUrl, response.statusCode ?? 0, response.body);

      return response;
    } catch (e) {
      ApiLogger.logError(fullUrl, e.toString());
      rethrow;
    }
  }
}

