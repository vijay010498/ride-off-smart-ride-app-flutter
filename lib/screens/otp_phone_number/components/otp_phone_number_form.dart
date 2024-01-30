import 'package:ride_off_smart_ride_app_flutter/screens/otp/otp_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/theme.dart';
import 'package:flutter/material.dart';
import '../../../components/custom_suffix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import '../../../theme.dart';

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

  @override
  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.phone,
            onSaved: (newValue) => phoneNumber = newValue,
            onChanged: (value){
              if(value.isNotEmpty){
                removeError(error: phoneNumberNullError);
              }
              return;
            },
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
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pushNamed(context, OtpScreen.routeName);
              }
            },
            child: const Text("Continue"),
          ),
        ],
      )

      );
  }
}