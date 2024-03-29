import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ride_off_smart_ride_app_flutter/services/api_services/auth.dart';
import 'package:ride_off_smart_ride_app_flutter/services/storage/secureStorageService.dart';

import '../Enums/httpenums.dart';
import '../config/apiconfig.dart';
import '../helpers/httpclient.dart';

class SignUpApiService{
    final SecureStorageService secureStorageService = SecureStorageService();
    
    Future<Map<String, dynamic>> signUpUser(String email, String firstName, String lastName) async {
      final String? accessToken = await secureStorageService.read(SecureStorageService.keyAccessToken);
      final payload = jsonEncode({'email': email,'firstName':firstName, 'lastName':lastName});
      final response =  await HttpClient.sendRequest(HttpMethod.POST, payload, '${ApiConfig.baseUrl}${ApiConfig.signUpEndpoint}',authToken: accessToken);
      return {'success': true};
  }
}