import 'dart:convert';
import 'dart:io';

import 'package:ride_off_smart_ride_app_flutter/Enums/httpenums.dart';
import 'package:http/http.dart' as http;
import 'package:ride_off_smart_ride_app_flutter/config/apiconfig.dart';

class VerificationApiService {
  // TODO check this function
  static Future<Map<String, dynamic>> sendImagesToBackend(
      File selfieImage, File photoIdImage) async {
    try {
      // Create multipart request
      var request = http.MultipartRequest(
        HttpMethod.POST.toString(),
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.faceVerification}'),
      );

      // Add selfie image to request
      request.files.add(
        http.MultipartFile(
          'selfie',
          selfieImage.readAsBytes().asStream(),
          selfieImage.lengthSync(),
          filename: selfieImage.path.split('/').last,
        ),
      );

      // Add photo ID image to request
      request.files.add(
        http.MultipartFile(
          'photoId',
          photoIdImage.readAsBytes().asStream(),
          photoIdImage.lengthSync(),
          filename: photoIdImage.path.split('/').last,
        ),
      );

      // Send request and get response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Check response status
      if (response.statusCode == 201) {
        // Request successful, parse response body
        return jsonDecode(response.body);
      } else {
        // Request failed, return error response
        return {
          'success': false,
          'message': 'Failed to send images to backend',
        };
      }
    } catch (e) {
      // Error occurred, return error response
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }
}
