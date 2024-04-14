import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:ride_off_smart_ride_app_flutter/Enums/httpenums.dart';

class HttpClient {
  static Future<http.Response>  sendRequest(
      HttpMethod method,
      String? payload,
      String uri, {
        String? authToken, // Optional Bearer token parameter
      }) async {
    final url = Uri.parse(uri);
    http.Response response;
    switch (method) {
      case HttpMethod.GET:
        response = await http.get(
          url,
          headers: _createHeaders(authToken),
        );
        break;
      case HttpMethod.POST:
        response = await http.post(
          url,
          headers: _createHeaders(authToken),
          body: payload,
        );
        
        Logger log = new Logger();
        log.i("url : $url");
        log.i("payload : $payload");
        log.i("headers : ${response.headers}");
        log.i("body : ${response.body}");
        
        break;
      case HttpMethod.PUT:
        response = await http.put(
          url,
          headers: _createHeaders(authToken),
          body: payload,
        );
        break;
      case HttpMethod.DELETE:
        response = await http.delete(
          url,
          headers: _createHeaders(authToken),
        );
        break;
      case HttpMethod.PATCH:
        response = await http.patch(
          url,
          headers: _createHeaders(authToken),
          body: payload,
        );
        break;
    }
    return response;
  }

  static Map<String, String> _createHeaders(String? authToken) {
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }
    return headers;
  }
}
