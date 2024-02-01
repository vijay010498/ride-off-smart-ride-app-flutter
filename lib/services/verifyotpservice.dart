import 'dart:convert';
import 'package:logger/logger.dart';

import '../Enums/httpenums.dart';
import '../config/apiconfig.dart';
import '../helpers/httpclient.dart';

class VerifyOtpApiService{

  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    try {
      final payload = jsonEncode({'phoneNumber': phoneNumber, 'userOtp': otp});
      final response = await HttpClient.sendRequest(
        HttpMethod.POST,
        payload,
        '${ApiConfig.baseUrl}${ApiConfig.verifyOtpEndpoint}',
      );
      if (response['message'] == "OTP Verified Successfully") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}