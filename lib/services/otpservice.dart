import 'dart:convert';

import '../Enums/httpenums.dart';
import '../config/apiconfig.dart';
import '../helpers/httpclient.dart';

class OtpApiService{

  Future<bool> generateOtp(String phoneNumber) async {
    try {
        final payload = jsonEncode({'phoneNumber': phoneNumber});
        final response = await HttpClient.sendRequest(HttpMethod.POST, payload, '${ApiConfig.baseUrlAuth}${ApiConfig.generateOtpEndpoint}');

        if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
          return true;
        } else  {
          print("Failed to generate OTP: ${response.reasonPhrase}");
          return false;
        }
      } catch(error) {
      print("_generateOtp----$error");
      rethrow;
    }
  }
}