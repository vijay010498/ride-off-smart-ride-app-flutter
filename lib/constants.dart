import 'package:flutter/material.dart';

const themePrimaryColor = Color(0xFFF57921);
const themePrimaryLightColor = Color(0xFFF3E5F5);
const themePrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFF57921)],
);
const themeSecondaryColor = Color(0xFFF57921);
const themeTextColor = Colors.black;

const themeAnimationDuration = Duration(milliseconds: 200);

const headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp validatorRegExp =
RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String emailNullError = "Empty email, please enter a valid email address";
const String invalidEmailError = "Invalid email address";
const String nameNullError = "Please Enter your name";
const String phoneNumberNullError = "Please Enter your phone number";
const String addressNullError = "Please Enter your address";
//Signup Error
const String firstNameNullError = "Please enter your first name";
const String lastNameNullError = "Please enter your last name";


final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 16),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(color: themeTextColor),
  );
}
