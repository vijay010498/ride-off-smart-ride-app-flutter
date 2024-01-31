import 'dart:convert';
import '../Enums/httpenums.dart';
import '../config/apiconfig.dart';
import '../helpers/httpclient.dart';

class VerifyOtpApiService{

  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp ) async {
    final payload = jsonEncode({'phoneNumber': phoneNumber, 'userOtp' : num.parse(otp)});
    return await HttpClient.sendRequest(HttpMethod.POST, '${ApiConfig.baseUrl}${ApiConfig.verifyOtpEndpoint}', payload );
  }
}