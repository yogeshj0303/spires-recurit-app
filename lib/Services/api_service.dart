import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spires_app/Constants/exports.dart';

class ApiService {
  static const int maxRetries = 3;
  static const Duration initialDelay = Duration(seconds: 1);
  
  static Future<http.Response> makeRequest(
    String url, {
    String method = 'POST',
    Map<String, String>? headers,
    Object? body,
  }) async {
    int attempts = 0;
    Duration delay = initialDelay;

    while (attempts < maxRetries) {
      try {
        http.Response response;
        
        switch (method.toUpperCase()) {
          case 'POST':
            response = await http.post(
              Uri.parse(url),
              headers: headers,
              body: body,
            );
            break;
          case 'GET':
            response = await http.get(
              Uri.parse(url),
              headers: headers,
            );
            break;
          default:
            throw Exception('Unsupported HTTP method: $method');
        }

        if (response.statusCode == 429) {
          // Get retry-after header or use exponential backoff
          final retryAfter = response.headers['retry-after'];
          if (retryAfter != null) {
            delay = Duration(seconds: int.parse(retryAfter));
          } else {
            delay *= 2; // Exponential backoff
          }
          
          attempts++;
          if (attempts < maxRetries) {
            await Future.delayed(delay);
            continue;
          }
        }
        
        return response;
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          rethrow;
        }
        await Future.delayed(delay);
        delay *= 2; // Exponential backoff
      }
    }
    
    throw Exception('Max retries exceeded');
  }
} 