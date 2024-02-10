import 'package:flutter/material.dart';
import 'components/otp_phone_number_form.dart';
import '../../../constants.dart';

class OtpPhoneNumberScreen extends StatelessWidget {
  static String routeName = "/otp_phone_number_screen";



  const OtpPhoneNumberScreen({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
        ),

      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text("Start", style: headingStyle),
                  const Text(
                    "Enter your phone number to begin",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 80),
                  const SizedBox(height: 16),
                  const OtpPhoneNumberForm(),
                  const SizedBox(height: 30),
                  Text(
                    "By continuing, you confirm that you agree \nwith our Terms and Conditions",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

}