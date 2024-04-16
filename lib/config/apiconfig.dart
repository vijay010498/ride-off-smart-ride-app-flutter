class ApiConfig {
  // Auth service
  static const String baseUrl = 'http://10.0.2.2/api';
  static const String generateOtpEndpoint = '/auth/otp/generate';
  static const String verifyOtpEndpoint = '/auth/otp/verify';
  static const String currentUserEndpoint = '/auth/user';
  static const String refreshTokenEndpoint = '/auth/token/refresh';

  static const String signUpEndpoint = '/auth/user/signup';

  static const String updateUserLocation = '/auth/user/location';
  static const String logoutUser = '/auth/user/logout';
  static const String getVehicleTypes = '/auth/profile/vehicle/types';
  static const String createNewVehicle = '/auth/profile/vehicle';
  static const String getUserVehicles = '/auth/profile/vehicles';

  static const String userOnlineStatus = '/auth/profile/status';

  // Verification service
  static const String faceVerification = '/verification/user';

  //Ride service
  static const String driverCreateRideEndPoint = '/ride/rides/driver';
  static const String passengerFindRideEndPoint = '/ride/rides/rider';
  static const String getVehiclesEndpoint = '/auth/profile/vehicles';

  // match service
  static const String getUserRides = '/match/ride/rides';
  static const String getUserRequests = '/match/ride/requests';
  static const String driverGivesPrice = '/match/ride/driver/givePrice';
  static const String driverDeclinesRequest =
      '/match/ride/driver/declineRequest';
  static const String driverAcceptsRequest = '/match/ride/driver/acceptRequest';


  static const String riderAcceptRequest = '/match/ride/rider/acceptRequest';

  static const String riderDeclinesRequest = '/match/ride/rider/declineRequest';

  static const String riderNegotiateRequest = '/match/ride/rider/negotiate';
}
