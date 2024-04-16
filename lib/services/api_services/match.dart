import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:ride_off_smart_ride_app_flutter/Enums/httpenums.dart';
import 'package:ride_off_smart_ride_app_flutter/config/apiconfig.dart';
import 'package:ride_off_smart_ride_app_flutter/helpers/httpclient.dart';

import '../storage/secureStorageService.dart';

class MatchService {
  final SecureStorageService secureStorageService = SecureStorageService();

  // Keys for secure storage
  static const String _keyAccessToken = SecureStorageService.keyAccessToken;


  Future<String?> _getAccessToken() async {
    return secureStorageService.read(_keyAccessToken);
  }

  Future<Map<String, dynamic>> getRides({String requestType = ''}) async {
    try {
      final accessToken = await _getAccessToken();
      var getRidesUrl = ApiConfig.getUserRides;

      if (requestType == 'driver' || requestType == 'rider') {
        getRidesUrl = '${ApiConfig.getUserRides}?requestType=$requestType';
      }

      final response = await HttpClient.sendRequest(
          HttpMethod.GET, null,
          '${ApiConfig.baseUrl}$getRidesUrl'
          , authToken: accessToken);

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        return {
          'driverRides': decodedResponse['ridesAsDriver'],
          'riderRides': decodedResponse['ridesAsRider']
        };
      }

      return {};
    } catch (error) {
      if (kDebugMode) {
        print("getRides-error----$error");
      }
      return {};
    }
  }

  Future getRequests({String requestType = ''}) async {
    try {
      final accessToken = await _getAccessToken();
      var getRequestsUrl = ApiConfig.getUserRequests;

      if (requestType == 'driver' || requestType == 'rider') {
        getRequestsUrl = '${ApiConfig.getUserRides}?requestType=$requestType';
      }

      final response = await HttpClient.sendRequest(
          HttpMethod.GET, null,
          '${ApiConfig.baseUrl}$getRequestsUrl'
          , authToken: accessToken);

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        return {
          'driverRequests': decodedResponse['requestsAsDriver'],
          'riderRequests': decodedResponse['requestsAsRider']
        };
      }
    } catch (error) {
      if (kDebugMode) {
        print("getRides-error----$error");
      }
    }
  }
}