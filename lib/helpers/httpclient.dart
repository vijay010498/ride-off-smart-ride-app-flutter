import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:ride_off_smart_ride_app_flutter/Enums/httpenums.dart';

class HttpClient{
  static Future<Map<String, dynamic>> sendRequest(HttpMethod method, String payload, String uri) async {
    final url = Uri.parse(uri);
    http.Response response;

    switch (method) {
      case HttpMethod.GET:
        response = await http.get(url);
        break;
      case HttpMethod.POST:
        response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: payload,
        );
        break;
      case HttpMethod.PUT:
        response = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: payload,
        );
        break;
      case HttpMethod.DELETE:
        response = await http.delete(url);
        break;
      case HttpMethod.PATCH:
        response = await http.patch(
          url,
          headers: {'Content-Type': 'application/json'},
          body: payload,
        );
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to make ${method.toString()} request: ${response.reasonPhrase}');
    }
  }
}