import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/otp/components/otp_form.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/otp/otp_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/otp_phone_number/otp_phone_number_screen.dart';
import 'screens/splash/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  OtpPhoneNumberScreen.routeName: (context) => const OtpPhoneNumberScreen(),
  // Modify route for OtpScreen to accept phone number argument
  OtpScreen.routeName: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as String; // Extract phone number from arguments
    return OtpScreen(phoneNumber: args); // Pass the phone number to OtpScreen
  },
};