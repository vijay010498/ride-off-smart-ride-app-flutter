//import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/blocked_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/home/home_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/otp/otp_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/otp_phone_number/otp_phone_number_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/verification/complete_verification.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/verification/face_verifications_options.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/verification/start_verification.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/signup/signup_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  OtpScreen.routeName: (context) => const OtpScreen(),
  OtpPhoneNumberScreen.routeName: (context) => const OtpPhoneNumberScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  FaceVerificationOptionsScreen.routeName: (context) => const FaceVerificationOptionsScreen(),
  StartVerification.routeName: (context) => const StartVerification(),
  CompleteVerification.routeName: (context) => const CompleteVerification(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  BlockedMessageWidget.routeName: (context) => const BlockedMessageWidget()
};