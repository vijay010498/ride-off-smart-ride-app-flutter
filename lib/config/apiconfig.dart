class ApiConfig {

  // Auth service
  static const String baseUrlAuth = 'http://10.0.2.2:3000/api';
  static const String generateOtpEndpoint = '/auth/otp/generate';
  static const String verifyOtpEndpoint = '/auth/otp/verify';
  static const String currentUserEndpoint = '/auth/user';
  static const String refreshTokenEndpoint = '/auth/token/refresh';

  // Verification service
  static const String baseUrlVerification = 'http://10.0.2.2:3001/api';
  static const String faceVerification = '/verification/user';
}