class ApiConfig {

  // Auth service
  static const String baseUrl = 'http://10.0.2.2/api';
  static const String generateOtpEndpoint = '/auth/otp/generate';
  static const String verifyOtpEndpoint = '/auth/otp/verify';
  static const String currentUserEndpoint = '/auth/user';
  static const String refreshTokenEndpoint = '/auth/token/refresh';
  static const String updateUserLocation = '/auth/user/location';
  static const String logoutUser = '/auth/user/logout';
  static const String getVehicleTypes = '/auth/profile/vehicle/types';
  static const String createNewVehicle = '/auth/profile/vehicle';
  static const String getUserVehicles = '/auth/profile/vehicles';
  // Verification service
  static const String faceVerification = '/verification/user';
}