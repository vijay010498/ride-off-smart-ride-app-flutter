import 'package:logger/logger.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/otp/otp_screen.dart';
import 'package:flutter/material.dart';
import '../../../components/custom_suffix_icon.dart';
import '../../../constants.dart';
import '../../../helpers/errorhelper.dart';
import '../../../helpers/textformathelper.dart';
import '../../../services/otpservice.dart';

class OtpPhoneNumberForm extends StatefulWidget{
  const OtpPhoneNumberForm({super.key});

  @override
  _OtpPhoneNumberFormState createState() => _OtpPhoneNumberFormState();
}

class _OtpPhoneNumberFormState extends State<OtpPhoneNumberForm>{
  final _formKey = GlobalKey<FormState>();

  final List<String?> errors = [];
  String? phoneNumber;

  void addError({String? error}){
    if(!errors.contains(error)){
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}){
    if(errors.contains(error)){
      setState(() {
        errors.remove(error);
      });
    }
  }

  void _handleOtpGenerationError(dynamic errorMessage) {
    ErrorHelper().showErrorMessage(context, errorMessage);
  }

  Future<bool> _generateOtp(String phoneNumber) async {
    try {
      Logger log = Logger();

      log.i("Received Phone Number : $phoneNumber");

      // Handle OTP generation response
      await new OtpApiService().generateOtp(phoneNumber);
      return true; // OTP generation successful
    } catch (error) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.phone,
            onChanged: (value){
              if(value.isNotEmpty){
                removeError(error: phoneNumberNullError);
                phoneNumber = value;
              }
              return;
            },
            maxLength: 10,
            validator: (value){
              if(value!.isEmpty){
                addError(error: phoneNumberNullError);
                return "";
              }
              return null;
            },

            decoration: const InputDecoration(
                labelText: "Phone Number",
                hintText: "Please enter your phone number",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Phone.svg")
            ),

          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String maskedPhoneNumber = TextFormatHelper.maskPhoneNumber(phoneNumber!);
                String formattedPhoneNumber = TextFormatHelper.formatPhoneNumber(phoneNumber!);

                bool otpGenerated = await _generateOtp(formattedPhoneNumber);
                Logger log = Logger();

                log.i("otpGenerated : $otpGenerated");


                if (otpGenerated) {
                  Map<String, String> arguments = {
                    'maskedPhoneNumber': maskedPhoneNumber,
                    'formattedPhoneNumber': formattedPhoneNumber
                  };
                  Navigator.pushNamed(context, OtpScreen.routeName, arguments: arguments);
                } else {
                  return _handleOtpGenerationError('Failed to generate OTP. Please try again.');
                }
              }
            },
            child: const Text("Continue"),
          ),
        ],
      )

      );
  }
}