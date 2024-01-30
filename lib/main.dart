import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/routes.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/splash/splash_screen.dart';
import '../../../constants.dart';
import '../../../theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Ride',
      theme: AppTheme.lightTheme(context),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}

