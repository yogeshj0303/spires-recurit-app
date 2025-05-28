import 'package:http/http.dart' as http;
import 'dart:convert';

class PhonepeService {
  static Future<String?> getAuthToken() async {
    print('🔑 [PhonePe] Starting auth token request...');
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://api-preprod.phonepe.com/apis/pg-sandbox/v1/oauth/token'));
    request.bodyFields = {
      'client_id': 'TEST-M2262FQ2G51D7_25050',
      'client_secret': 'ZDViYzI4MzgtODQ4Ny00M2YyLWFjYzItZmI2MTU5NTU1ZDIy',
      'grant_type': 'client_credentials',
      'client_version': '1.0'
    };
    request.headers.addAll(headers);

    print('🔑 [PhonePe] Auth request headers: $headers');
    print('🔑 [PhonePe] Auth request body: ${request.bodyFields}');

    try {
      print('🔑 [PhonePe] Sending auth request...');
      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      print('🔑 [PhonePe] Auth response status: ${response.statusCode}');
      print('🔑 [PhonePe] Auth response body: $responseBody');
      
      if (response.statusCode == 200) {
        final data = json.decode(responseBody);
        final token = data['access_token'];
        print('🔑 [PhonePe] Successfully obtained auth token');
        return token;
      } else {
        print('❌ [PhonePe] Auth token error: ${response.reasonPhrase}');
        print('❌ [PhonePe] Error response: $responseBody');
        return null;
      }
    } catch (e, stackTrace) {
      print('❌ [PhonePe] Auth token error: $e');
      print('❌ [PhonePe] Stack trace: $stackTrace');
      return null;
    }
  }
}
