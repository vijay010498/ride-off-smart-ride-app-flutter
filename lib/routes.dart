//import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/otp/components/otp_form.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/otp/otp_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/otp_phone_number/otp_phone_number_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/signup/signup_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  OtpScreen.routeName: (context) => const OtpScreen(),
  OtpPhoneNumberScreen.routeName: (context) => const OtpPhoneNumberScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen()
};