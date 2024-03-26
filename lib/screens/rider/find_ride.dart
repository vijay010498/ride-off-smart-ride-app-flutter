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

class PassengerDetails {
  String? startAddress = "";
  String? destinationAddress = "";
  int? seats;
  String? luggage = "";
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
}

class FindPassengerRide extends StatelessWidget {
  static String routeName = "/find_ride";
  const FindPassengerRide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PassengerDetailsScreen(),
    );
  }
}

class PassengerDetailsScreen extends StatefulWidget {
  @override
  _PassengerDetailsScreenState createState() => _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends State<PassengerDetailsScreen> {
  final StartController = TextEditingController();
  final DestinationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  PassengerDetails passengerDetails = PassengerDetails();
  final List<String?> errors = [];

  @override
  void dispose() {
    StartController.dispose();
    DestinationController.dispose();
    super.dispose();
  }
  final predictionListContainer = [];
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
            Logger log = new Logger();
            
        if (result.predictions != null) {
          setState(() {
            predictionsList.clear(); 
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
        title: Text('Passenger Details'),
      ),
      body: Padding(
        
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Enter Passenger Details", style: headingStyle),
              Text("Fill the form to enter passenger details", textAlign: TextAlign.center),
              SizedBox(height: 30),
              Expanded(
              child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    FormError(errors: errors),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: StartController,
                      onSaved: (newValue) => passengerDetails.startAddress = newValue,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          removeError(error: startNullError);
                          passengerDetails.startAddress = value;
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
                        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
                      ),
                    ),
                    if (StartPredicitions.isNotEmpty)
                    PredictionListContainer(
                      predictions: StartPredicitions,
                      onPredictionSelected: (selectedPrediction) {
                        setState(() {
                          passengerDetails.startAddress = selectedPrediction; 
                          StartController.text = selectedPrediction; 
                          StartPredicitions.clear(); 
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: DestinationController,
                      onSaved: (newValue) => passengerDetails.destinationAddress = newValue,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          removeError(error: destinationNullError);
                          passengerDetails.destinationAddress = value;
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
                        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
                      ),
                    ),
                    if (DestinationPredicitions.isNotEmpty)
                      PredictionListContainer(
                        predictions: DestinationPredicitions,
                        onPredictionSelected: (selectedPrediction) {
                          setState(() {
                            passengerDetails.destinationAddress = selectedPrediction; 
                            DestinationController.text = selectedPrediction; 
                            DestinationPredicitions.clear(); 
                          });
                        },
                      ),
                    SizedBox(height: 20),
                    TextFormField(
                      onSaved: (newValue) => passengerDetails.seats = int.parse(newValue!),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          removeError(error: seatsNullError);
                        }
                        return;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          addError(error: seatsNullError);
                          return "";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Number of Seats",
                        hintText: "Enter the number of seats",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      onSaved: (newValue) => passengerDetails.luggage = newValue,
                      onChanged: (value) {
                        return;
                      },
                      decoration: const InputDecoration(
                        labelText: "Luggage",
                        hintText: "Number of Luggages",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildDateTimePicker('Date', passengerDetails.date, (value) {
                      setState(() {
                        passengerDetails.date = value;
                      });
                    }),
                    SizedBox(height: 20),
                    _buildDateTimePicker('Time', passengerDetails.time, (value) {
                      setState(() {
                        passengerDetails.time = value;
                      });
                    }),
                    SizedBox(height: 20),
                    
                    ElevatedButton(
                      onPressed: () async {
                        // TODO: Connect to backend

                        if (_formKey.currentState!.validate()) {
                          Logger log = new Logger();
                          log.i("Saved passenger details");
                        }
                      },
                      child: Text('Save Passenger Details'),
                    ),
                  ],
                ),
              ),
              ),
              ),
            ],
          ),
        ),
      )
      );
    
  }

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
