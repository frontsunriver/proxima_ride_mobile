import 'dart:developer' as developer;
import 'dart:convert';

class ApiLogger {
  static const String _tag = '🌐 API';
  
  /// Log API GET request
  static void logGetRequest(String url, Map<String, String>? headers) {
    developer.log(
      '📤 GET REQUEST\n'
      '└─ URL: $url\n'
      '└─ Headers: ${_prettyPrint(headers)}',
      name: _tag,
    );
    print('\n${'=' * 80}');
    print('📤 GET REQUEST');
    print('URL: $url');
    print('Headers: ${_prettyPrint(headers)}');
    print('${'=' * 80}\n');
  }

  /// Log API POST request
  static void logPostRequest(String url, dynamic data, Map<String, String>? headers) {
    developer.log(
      '📤 POST REQUEST\n'
      '└─ URL: $url\n'
      '└─ Headers: ${_prettyPrint(headers)}\n'
      '└─ Data: ${_prettyPrint(data)}',
      name: _tag,
    );
    print('\n${'=' * 80}');
    print('📤 POST REQUEST');
    print('URL: $url');
    print('Headers: ${_prettyPrint(headers)}');
    print('POST Data: ${_prettyPrint(data)}');
    print('${'=' * 80}\n');
  }

  /// Log API PUT request
  static void logPutRequest(String url, dynamic data, Map<String, String>? headers) {
    developer.log(
      '📤 PUT REQUEST\n'
      '└─ URL: $url\n'
      '└─ Headers: ${_prettyPrint(headers)}\n'
      '└─ Data: ${_prettyPrint(data)}',
      name: _tag,
    );
    print('\n${'=' * 80}');
    print('📤 PUT REQUEST');
    print('URL: $url');
    print('Headers: ${_prettyPrint(headers)}');
    print('PUT Data: ${_prettyPrint(data)}');
    print('${'=' * 80}\n');
  }

  /// Log API DELETE request
  static void logDeleteRequest(String url, Map<String, String>? headers) {
    developer.log(
      '📤 DELETE REQUEST\n'
      '└─ URL: $url\n'
      '└─ Headers: ${_prettyPrint(headers)}',
      name: _tag,
    );
    print('\n${'=' * 80}');
    print('📤 DELETE REQUEST');
    print('URL: $url');
    print('Headers: ${_prettyPrint(headers)}');
    print('${'=' * 80}\n');
  }

  /// Log API response
  static void logResponse(String url, int statusCode, dynamic responseBody) {
    final emoji = statusCode >= 200 && statusCode < 300 ? '✅' : '❌';
    developer.log(
      '$emoji RESPONSE\n'
      '└─ URL: $url\n'
      '└─ Status Code: $statusCode\n'
      '└─ Response: ${_prettyPrint(responseBody)}',
      name: _tag,
    );
    print('\n${'=' * 80}');
    print('$emoji RESPONSE');
    print('URL: $url');
    print('Status Code: $statusCode');
    print('Response Body: ${_prettyPrint(responseBody)}');
    print('${'=' * 80}\n');
  }

  /// Log API error
  static void logError(String url, String error) {
    developer.log(
      '❌ ERROR\n'
      '└─ URL: $url\n'
      '└─ Error: $error',
      name: _tag,
    );
    print('\n${'=' * 80}');
    print('❌ API ERROR');
    print('URL: $url');
    print('Error: $error');
    print('${'=' * 80}\n');
  }

  /// Pretty print JSON or any object
  static String _prettyPrint(dynamic data) {
    try {
      if (data == null) return 'null';
      if (data is String) return data;
      if (data is Map || data is List) {
        const encoder = JsonEncoder.withIndent('  ');
        return '\n${encoder.convert(data)}';
      }
      return data.toString();
    } catch (e) {
      return data.toString();
    }
  }
}

