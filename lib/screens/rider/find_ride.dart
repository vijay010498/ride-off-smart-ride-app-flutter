import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ride_off_smart_ride_app_flutter/Enums/httpenums.dart';
import 'package:ride_off_smart_ride_app_flutter/components/autocomplete_prediction.dart';
import 'package:ride_off_smart_ride_app_flutter/components/place_auto_complete_response.dart';
import 'package:ride_off_smart_ride_app_flutter/components/prediction_list_component.dart';
import 'package:ride_off_smart_ride_app_flutter/helpers/errorhelper.dart';
import 'package:ride_off_smart_ride_app_flutter/helpers/httpclient.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/choose_type_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/services/riderFindRideService.dart';
import '../../../components/custom_suffix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import 'package:intl/intl.dart';

class PassengerDetails {
  String? startAddress = "";
  String? destinationAddress = "";
  int? seats;
  int maxPrice = 1;
  String date = DateTime.now().toString();
  TimeOfDay time = TimeOfDay.now();
  String? tripDescription;
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

  void _handleCreateRideError(dynamic errorMessage) {
    new ErrorHelper().showErrorMessage(context, errorMessage);
  }


Future<void> find_Passenger_Ride(String startAddress, String destinationAddress, String date, int emptySeats, int maxPrice, String tripDescription) async {
  try {
        Map<String, dynamic>? response = await new RiderFindRideService().findRide(startAddress, destinationAddress, date, emptySeats, maxPrice, tripDescription);
        Logger log = new Logger();
        log.i('response service: ${response}');
        if (response is Map<String, dynamic>) {
          if (response.containsKey('error')) {
            _handleCreateRideError(response['error']);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Finding Ride Details'),
                duration: Duration(seconds: 2),
              ),
            );
            Navigator.pushNamed(context, ChooseOptionScreen.routeName);
          }
        } else {
          _handleCreateRideError('Unexpected response format');
        }
      } catch (error) {
        _handleCreateRideError(error);
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
              
              SingleChildScrollView(
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
                      onPredictionSelected:  (selectedPrediction, placeId) {
                        setState(() {
                          passengerDetails.startAddress = placeId; 
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
                        onPredictionSelected:  (selectedPrediction, placeId){
                          setState(() {
                            passengerDetails.destinationAddress = placeId; 
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
                        passengerDetails.seats = int.parse(value);
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
                      keyboardType: TextInputType.number,
                      initialValue: '1', 
                      onChanged: (value) {
                      int? parsedValue = int.tryParse(value);
                      if (parsedValue != null && parsedValue > 0) {
                          removeError(error: priceNullError);
                        }
                        return;
                      },
                      validator: (value) {
                        int? parsedValue = int.tryParse(value!);
                        if (parsedValue == null || parsedValue <= 0) {
                          addError(error: priceNullError);
                          return "";
                        }
                        return null;
                      },
                    decoration: const InputDecoration(
                      labelText: "Empty Seats",
                      hintText: "Number of empty seats",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: Icon(Icons.event_seat),
                    ),
                  ),
                    SizedBox(height: 20),
                    _buildDateTimePicker('Date', passengerDetails.date, (value) {
                    setState(() {
                      passengerDetails.date = DateFormat('yyyy-MM-dd hh:mm a').format(value);
                    });
                  }),
                    SizedBox(height: 20),
                    TextFormField(
                      maxLines: 3,
                      onChanged: (value) {
                        setState(() {
                          passengerDetails.tripDescription = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Trip Description',
                        hintText: 'Enter a description for your trip (optional)',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        
                        if (_formKey.currentState!.validate()) {
                          find_Passenger_Ride(passengerDetails.startAddress!, passengerDetails.destinationAddress!, passengerDetails.date, passengerDetails.seats!, passengerDetails.maxPrice, passengerDetails.tripDescription!);
                        }
                      },
                      child: Text('Finding Ride Details'),
                    ),
                  ],
                ),
              ),
              ),
              
            ],
          ),
        ),
      )
      );
    
  }

  Widget _buildDateTimePicker(
  String label, String value, Function(DateTime) onChanged) {
  DateTime initialValue = DateFormat('yyyy-MM-dd HH:mm').parse(value);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text('$label:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      SizedBox(height: 20),
      // Input field for date and time
      TextButton(
        onPressed: () async {
          DateTime? pickedDateTime = await showDatePicker(
            context: context,
            initialDate: initialValue,
            firstDate: DateTime.now(),
            lastDate: DateTime(2101),
          );

          if (pickedDateTime != null) {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(initialValue),
            );

            if (pickedTime != null) {
              pickedDateTime = DateTime(
                pickedDateTime.year,
                pickedDateTime.month,
                pickedDateTime.day,
                pickedTime.hour,
                pickedTime.minute,
              );

              onChanged(pickedDateTime);
            }
          }
        },
        child: Text(
          '$value',
          style: TextStyle(fontSize: 18),
        ),
      ),
    ],
  );
}
}
