import 'dart:convert';

import '../Enums/httpenums.dart';
import '../config/apiconfig.dart';
import '../helpers/httpclient.dart';

class VerifyOtpApiService{

  Future<Map<String, bool>> verifyOtp(String phoneNumber, String otp) async {
    try {
      final payload = jsonEncode({'phoneNumber': phoneNumber, 'userOtp': otp});
      final response = await HttpClient.sendRequest(
        HttpMethod.POST,
        payload,
        '${ApiConfig.baseUrlAuth}${ApiConfig.verifyOtpEndpoint}',
      );

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        // TODO get access and refresh token save into secure storage
        final isSignedUp = responseBody['isSignedUp'] as bool;

        return { 'success': true, 'isSignedUp':isSignedUp };
      } else {
        print("Failed to Verify OTP: ${response.reasonPhrase}");
        return { 'success': false, 'isSignedUp':false };;
      }
    } catch (error) {
      print("verifyOtp----$error");
      return { 'success': false, 'isSignedUp':false };;
    }
  }
}