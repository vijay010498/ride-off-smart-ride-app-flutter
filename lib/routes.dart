//import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/blocked_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/choose_type_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/driver/create_ride_form.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/home/home_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/otp/otp_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/otp_phone_number/otp_phone_number_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/rider/find_ride.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/verification/face_verifications_options.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/bottom_navigation_bar.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/vehicles/add_vehicle.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/vehicles/vehicles_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/signup/signup_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  OtpScreen.routeName: (context) => const OtpScreen(),
  OtpPhoneNumberScreen.routeName: (context) => const OtpPhoneNumberScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  FaceVerificationOptionsScreen.routeName: (context) =>
      const FaceVerificationOptionsScreen(),
  HomeScreen.routeName: (context) => const BottomNavigationBarWidget(),
  BlockedMessageWidget.routeName: (context) => const BlockedMessageWidget(),
  AddVehicleScreenWidget.routeName: (context) => const AddVehicleScreenWidget(),
  VehiclesScreenWidget.routeName: (context) => const VehiclesScreenWidget(),
  HomeScreen.routeName: (context) => const BottomNavigationBarWidget(),
  BlockedMessageWidget.routeName: (context) => const BlockedMessageWidget(),
  ChooseOptionScreen.routeName: (context) => const ChooseOptionScreen(),
  CreateRideScreen.routeName: (context) => const CreateRideScreen(),
  FindPassengerRide.routeName: (context) => const FindPassengerRide(),
  AddVehicleScreenWidget.routeName: (context) => const AddVehicleScreenWidget(),
  VehiclesScreenWidget.routeName: (context) => const VehiclesScreenWidget()
};
