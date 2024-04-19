import 'dart:convert';
import 'package:ride_off_smart_ride_app_flutter/services/storage/secureStorageService.dart';

import '../Enums/httpenums.dart';
import '../config/apiconfig.dart';
import '../helpers/httpclient.dart';
import '../main.dart';

class SignUpApiService{
    Future<Map<String, dynamic>> signUpUser(String email, String firstName, String lastName) async {
      final String? accessToken = await storageService.read(SecureStorageService.keyAccessToken);
      final payload = jsonEncode({'email': email,'firstName':firstName, 'lastName':lastName});
      final response =  await HttpClient.sendRequest(HttpMethod.POST, payload, '${ApiConfig.baseUrl}${ApiConfig.signUpEndpoint}',authToken: accessToken);
      return {'success': true};
  }
}