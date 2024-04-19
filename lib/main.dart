import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/routes.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/splash/splash_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/services/storage/mobile_storage_service.dart';
import 'package:ride_off_smart_ride_app_flutter/services/storage/storage_service.dart';
import 'package:ride_off_smart_ride_app_flutter/services/storage/web_storage_service.dart';
import '../../../theme.dart';

late StorageService storageService;
void main() {
  setupStorageService();
  runApp(const MyApp());
}

void setupStorageService() {
  if (kIsWeb) {
    print('ias-web');
    storageService = WebStorageService();
  } else {
    storageService = MobileStorageService();
  }
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

