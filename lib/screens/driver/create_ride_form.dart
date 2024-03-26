import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ride_off_smart_ride_app_flutter/Enums/httpenums.dart';
import 'package:ride_off_smart_ride_app_flutter/components/autocomplete_prediction.dart';
import 'package:ride_off_smart_ride_app_flutter/components/place_auto_complete_response.dart';
import 'package:ride_off_smart_ride_app_flutter/components/prediction_list_component.dart';
import 'package:ride_off_smart_ride_app_flutter/helpers/errorhelper.dart';
import 'package:ride_off_smart_ride_app_flutter/helpers/httpclient.dart';
import '../../../components/custom_suffix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  final StopsController = TextEditingController();
  final StartController = TextEditingController();
  final DestinationController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   textController = TextEditingController();
  // }

  @override
  void dispose() {
    StartController.dispose();
    StopsController.dispose();
    DestinationController.dispose();
    super.dispose();
  }
  final predictionListContainer = [];
  final _formKey = GlobalKey<FormState>();
  RideDetails rideDetails = RideDetails();

  List<AutoCompletePrediction> StopsPredicitions = [];
  List<AutoCompletePrediction> StartPredicitions = [];
  List<AutoCompletePrediction> DestinationPredicitions = [];
  
  void placeAutoComplete(String query, List<AutoCompletePrediction> predictionsList) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      'maps/api/place/autocomplete/json',
      {"input": query, "key": placesAPI},
    );

    try {
      final response =
          await HttpClient.sendRequest(HttpMethod.GET, null, uri.toString());

      final httpResponse = await response;
      String responseBody = response.body;
      if (httpResponse.statusCode == 200) {
        PlaceAutoCompleteResponse result =
            PlaceAutoCompleteResponse.parseAutoCompleteResult(responseBody);
        if (result.predictions != null) {
          setState(() {
            predictionsList.clear(); // Clear the existing list
          predictionsList.addAll(result.predictions!);
          });
        }
      } else {
        // Handle errors or non-200 status codes
        print('Request failed with status: ${httpResponse.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Request failed: $e');
    }
  }

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
                          rideDetails.carBrand = value;
                        }
                        return;
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
                        suffixIcon:
                            CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
                      ),
                    ),

                    SizedBox(height: 20),
                    TextFormField(
                      onSaved: (newValue) => rideDetails.carModel = newValue,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          removeError(error: modelNullError);
                          rideDetails.carModel = value;
                        }
                        return;
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
                        suffixIcon:
                            CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: StartController,
                      onSaved: (newValue) =>
                          rideDetails.startAddress = newValue,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          removeError(error: startNullError);
                          rideDetails.startAddress = value;
                        }
                        placeAutoComplete(value, StartPredicitions);
                        return;
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
                        suffixIcon:
                            CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
                      ),
                    ),
                    if (StartPredicitions.isNotEmpty)
                    PredictionListContainer(
                      predictions: StartPredicitions,
                      onPredictionSelected: (selectedPrediction) {
                        setState(() {
                          rideDetails.stops = selectedPrediction; 
                          StartController.text = selectedPrediction; 
                          StartPredicitions.clear(); 
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: StopsController,
                      onSaved: (newValue) => rideDetails.stops = newValue,
                      onChanged: (value) {
                        placeAutoComplete(value,StopsPredicitions);
                        return;
                      },
                      
                      decoration: const InputDecoration(
                        labelText: "Stops",
                        hintText: "Optional Stops",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon:
                            CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
                      ),
                    ),

                    if (StopsPredicitions.isNotEmpty)
                    PredictionListContainer(
                      predictions: StopsPredicitions,
                      onPredictionSelected: (selectedPrediction) {
                        setState(() {
                          rideDetails.stops = selectedPrediction; 
                          StopsController.text = selectedPrediction; 
                          StopsPredicitions.clear(); 
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: DestinationController,
                      onSaved: (newValue) =>
                          rideDetails.destinationAddress = newValue,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          removeError(error: destinationNullError);
                          rideDetails.destinationAddress = value;
                        }
                        placeAutoComplete(value,DestinationPredicitions);
                        return;
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
                        suffixIcon:
                            CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
                      ),
                    ),
                    if (DestinationPredicitions.isNotEmpty)
                    PredictionListContainer(
                      predictions: DestinationPredicitions,
                      onPredictionSelected: (selectedPrediction) {
                        setState(() {
                          rideDetails.destinationAddress = selectedPrediction; 
                          DestinationController.text = selectedPrediction; 
                          DestinationPredicitions.clear(); 
                        });
                      },
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
                        //   //TODO: Conenct to backend

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

  Widget _buildDateTimePicker(
      String label, dynamic value, Function(dynamic) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('$label:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
