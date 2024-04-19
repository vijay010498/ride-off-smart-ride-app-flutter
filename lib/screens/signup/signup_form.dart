import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/helpers/errorhelper.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/choose_type_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/services/signupservice.dart';
import '../../../components/custom_suffix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final List<String?> errors = [];
  String? email;
  String? firstName;
  String? lastName;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

void _handleSignUpError(dynamic errorMessage) {
    ErrorHelper().showErrorMessage(context, errorMessage);
  }

  void _signUpUser(String email, String firstName, String lastName) async {
      try {
        Map<String, dynamic> response = await SignUpApiService().signUpUser(email, firstName, lastName);
        bool success = response['success']!;
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Signed Up Successfully'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (error) {
        _handleSignUpError(error);
       }
    }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: emailNullError);
                email=value;
              } else if (validatorRegExp.hasMatch(value)) {
                removeError(error: invalidEmailError);
                email=value;
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: emailNullError);
                return "";
              } else if (!validatorRegExp.hasMatch(value)) {
                addError(error: invalidEmailError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          const SizedBox(height: 30),
          TextFormField(
            onSaved: (newValue) => firstName = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: firstNameNullError);
                firstName=value;
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: firstNameNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "First Name",
              hintText: "Enter your first name",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 30),
          TextFormField(
            onSaved: (newValue) => lastName = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: lastNameNullError);
                lastName = value;
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: lastNameNullError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Last Name",
              hintText: "Enter your last name",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),
          FormError(errors: errors),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
                if (_formKey.currentState!.validate()) {
                   _signUpUser(email!,firstName!,lastName!);
                  }
                  Navigator.pushNamed(context, ChooseOptionScreen.routeName);
               
                
              },
              child: const Text("Continue"),
            ),
        ],
      ),
    );
  }
}
