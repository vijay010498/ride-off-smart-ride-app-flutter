import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/services/verifyotpservice.dart';

import 'package:ride_off_smart_ride_app_flutter/screens/signup/signup_screen.dart';
import '../../../constants.dart';
import '../../../theme.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({
    Key? key,
  }) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;

  String collatedOTP = '';

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
    pin5FocusNode!.dispose();
    pin6FocusNode!.dispose();
  }

  void clearForm(){
    pin2FocusNode!.unfocus(); // Ensure focus is removed from all fields
    pin3FocusNode!.unfocus();
    pin4FocusNode!.unfocus();
    pin5FocusNode!.unfocus();
    pin6FocusNode!.unfocus();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  void _verifyOtp(String otp, String formattedPhoneNumber) async {
    bool isOtpValid = await VerifyOtpApiService().verifyOtp(formattedPhoneNumber,  otp);
    if (isOtpValid) {
      // Display success message (Snackbar or navigate to next screen)
      collatedOTP = '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP Verified Successfully'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pushNamed(context, SignUpScreen.routeName);
    } else {
      // Display error message
      collatedOTP = '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid OTP. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );

      clearForm();
    }
  }

  @override
  Widget build(BuildContext context) {

    Map<String, String> arguments = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    String formattedPhoneNumber = arguments['formattedPhoneNumber']!;

    return Form(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 45,
                child: TextFormField(
                  autofocus: true,
                  obscureText: true,
                  style: const TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    collatedOTP = collatedOTP + value;
                    nextField(value, pin2FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: 45,
                child: TextFormField(
                  focusNode: pin2FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    collatedOTP = collatedOTP + value;
                    nextField(value, pin3FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: 45,
                child: TextFormField(
                  focusNode: pin3FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value){
                    collatedOTP = collatedOTP + value;
                    nextField(value, pin4FocusNode);
                    },
                ),
              ),
              SizedBox(
                width: 45,
                child: TextFormField(
                  focusNode: pin4FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value){
                    collatedOTP = collatedOTP + value;
                    nextField(value, pin5FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: 45,
                child: TextFormField(
                  focusNode: pin5FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    collatedOTP = collatedOTP + value;
                    nextField(value, pin6FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: 45,
                child: TextFormField(
                  focusNode: pin6FocusNode,
                  obscureText: true,
                  style: const TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    collatedOTP = collatedOTP + value;
                    if (value.length == 1) {
                      pin6FocusNode!.unfocus();
                      // Then you need to check is the code is correct or not
                    }
                  },
                ),
              )
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          ElevatedButton(
            onPressed: () {
              _verifyOtp(collatedOTP, formattedPhoneNumber);
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}
