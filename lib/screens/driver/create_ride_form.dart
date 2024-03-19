    import 'package:flutter/material.dart';
    import 'package:logger/logger.dart';
    import 'package:ride_off_smart_ride_app_flutter/helpers/errorhelper.dart';
    import '../../../components/custom_suffix_icon.dart';
    import '../../../components/form_error.dart';
    import '../../../constants.dart';


    class RideDetails {
      String? carBrand = "";
      String? carModel = "";
      String? startAddress = "";
      //List<String> stops = [];
      String? stops = "";
      String? destinationAddress = "";
      DateTime date = DateTime.now();
      TimeOfDay time = TimeOfDay.now();
    }

    class CreateRideScreen extends StatelessWidget {
      static String routeName = "/create_ride_form";
      const CreateRideScreen({super.key});

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: RideDetailsScreen(),
        );
      }
    }

    class RideDetailsScreen extends StatefulWidget {
      @override
      _RideDetailsScreenState createState() => _RideDetailsScreenState();
    }

    class _RideDetailsScreenState extends State<RideDetailsScreen> {
      final _formKey = GlobalKey<FormState>();
      RideDetails rideDetails = RideDetails();
      final List<String?> errors = [];
      void addError({String? error}) {
        if (!errors.contains(error)) {
          Logger log = new Logger();
          log.i("error $error");
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

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Ride Details'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Create a ride", style: headingStyle),
                  Text("Fill form to create a ride", textAlign: TextAlign.center),
                  SizedBox(height: 30),
                  SizedBox(height: 10),
                  FormError(errors: errors),
                  Form(
                    key: _formKey,
                    child: Column(
                    children: [
                      SizedBox(height: 20),
                      TextFormField(
                        onSaved: (newValue) => rideDetails.carBrand = newValue,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            removeError(error: brandNullError);
                            rideDetails.carBrand=value;
                          }return;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            addError(error: brandNullError);
                            return "";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: "Brand",
                          hintText: "Car Brand",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
                        ),
                      ),

                      SizedBox(height: 20),
                      TextFormField(
                        onSaved: (newValue) => rideDetails.carModel = newValue,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            removeError(error: modelNullError);
                            rideDetails.carModel=value;
                          }return;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            addError(error: modelNullError);
                            return "";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: "Model",
                          hintText: "Car Model",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        onSaved: (newValue) => rideDetails.startAddress = newValue,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            removeError(error: startNullError);
                            rideDetails.startAddress=value;
                          }return;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            addError(error: startNullError);
                            return "";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: "Start Address",
                          hintText: "Start Address",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        onSaved: (newValue) => rideDetails.stops = newValue,
                        onChanged: (value) {
                          return;
                        },
                        decoration: const InputDecoration(
                          labelText: "Stops",
                          hintText: "Optional Stops",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
                        ),
                      ),
                      //_buildStopsList(),
                      SizedBox(height: 20),
                      TextFormField(
                        onSaved: (newValue) => rideDetails.destinationAddress = newValue,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            removeError(error: destinationNullError);
                            rideDetails.destinationAddress=value;
                          }return;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            addError(error: destinationNullError);
                            return "";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: "Destination Address",
                          hintText: "Destination Address",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildDateTimePicker('Date', rideDetails.date, (value) {
                        setState(() {
                          rideDetails.date = value;
                        });
                      }),
                      SizedBox(height: 20),
                      _buildDateTimePicker('Time', rideDetails.time, (value) {
                        setState(() {
                          rideDetails.time = value;
                        });
                      }),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          //TODO: Conenct to backend

                        if (_formKey.currentState!.validate()) {
                          Logger log = new Logger();
                          log.i("Saved ride details");
                          }
                        
                      },
                        child: Text('Save Ride Details'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ),
        );
      }

      Widget _buildTextField(String label, String value, Function(String) onChanged) {
        return TextField(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
          onChanged: onChanged,
          controller: TextEditingController(text: value),
        );
      }

    //   Widget _buildStopsList() {
    //   return Column(
    //     crossAxisAlignment: CrossAxisAlignment.stretch,
    //     children: [
    //       _buildTextField('Stop 1', rideDetails.stops.length > 0 ? rideDetails.stops[0] : '', (value) {
    //         setState(() {
    //           if (rideDetails.stops.length > 0) {
    //             rideDetails.stops[0] = value;
    //           } else {
    //             rideDetails.stops.add(value);
    //           }
    //         });
    //       }),
    //       SizedBox(height: 20),
    //       _buildTextField('Stop 2', rideDetails.stops.length > 1 ? rideDetails.stops[1] : '', (value) {
    //         setState(() {
    //           if (rideDetails.stops.length > 1) {
    //             rideDetails.stops[1] = value;
    //           } else {
    //             rideDetails.stops.add(value);
    //           }
    //         });
    //       }),
    //       // Add more stop input fields as needed
    //     ],
    //   );
    // }

      Widget _buildDateTimePicker(String label, dynamic value, Function(dynamic) onChanged) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('$label:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          // Input field for date and time
          if (label == 'Date')
            TextButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: value,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null && pickedDate != value) {
                  onChanged(pickedDate);
                }
              },
              child: Text(
                '${value.year}-${value.month}-${value.day}',
                style: TextStyle(fontSize: 18),
              ),
            ),
          if (label == 'Time')
            TextButton(
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: value,
                );

                if (pickedTime != null && pickedTime != value) {
                  onChanged(pickedTime);
                }
              },
              child: Text(
                '${value.hour}:${value.minute}',
                style: TextStyle(fontSize: 18),
              ),
            ),
        ],
      );
    }
    }
