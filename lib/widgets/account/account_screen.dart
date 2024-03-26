import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/services/api_services/auth.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/account/profile_section.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/account/settings_item.dart';

import '../../screens/otp_phone_number/otp_phone_number_screen.dart';
import '../vehicles/vehicles_screen.dart';

class AccountScreenWidget extends StatelessWidget {
  const AccountScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          const ProfileSectionWidget(),
          Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery
                    .of(context)
                    .size
                    .height *
                    0.8), // Adjust the maxHeight as needed
            child: Column(
              children: [
                SettingsItemWidget(title: 'My Vehicles', onTap: () {
                  Navigator.pushNamed(context, VehiclesScreenWidget.routeName);
                },),
                SettingsItemWidget(
                  title: 'Log out',
                  onTap: () async {
                    // Show loading indicator
                    showLoadingDialog(context);
                    try {
                      final AuthService authService = AuthService();
                      await authService.logoutUser();
                      // Navigate to OTP screen after logout
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        OtpPhoneNumberScreen.routeName,
                            (route) => false,
                      );
                    } catch (error) {
                      if (kDebugMode) {
                        print('Logout -error---$error');
                      }
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        OtpPhoneNumberScreen.routeName,
                            (route) => false,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Logging out..."),
            ],
          ),
        );
      },
    );
  }
}
