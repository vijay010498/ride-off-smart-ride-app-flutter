import 'dart:convert';
import '../Enums/httpenums.dart';
import '../config/apiconfig.dart';
import '../helpers/httpclient.dart';

class OtpApiService{

  Future<Map<String, dynamic>> generateOtp(String phoneNumber) async {
    final payload = jsonEncode({'phoneNumber': phoneNumber});
    return await HttpClient.sendRequest(HttpMethod.POST, '${ApiConfig.baseUrl}${ApiConfig.generateOtpEndpoint}', payload );
  }
}