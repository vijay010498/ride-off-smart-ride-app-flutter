import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:ride_off_smart_ride_app_flutter/Enums/httpenums.dart';
import 'package:ride_off_smart_ride_app_flutter/components/autocomplete_prediction.dart';
import 'package:ride_off_smart_ride_app_flutter/components/place_auto_complete_response.dart';
import 'package:ride_off_smart_ride_app_flutter/components/prediction_list_component.dart';
import 'package:ride_off_smart_ride_app_flutter/config/apiconfig.dart';
import 'package:ride_off_smart_ride_app_flutter/helpers/errorhelper.dart';
import 'package:ride_off_smart_ride_app_flutter/helpers/httpclient.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/choose_type_screen.dart';
import 'package:ride_off_smart_ride_app_flutter/services/driverCreateRideService.dart';
import 'package:ride_off_smart_ride_app_flutter/services/storage/secureStorageService.dart';
import '../../../components/custom_suffix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class RideDetails {
String? vehicleId = "";
String? startAddress = "";
List<String> stops = [];
// String? stops = "";
String? destinationAddress = "";
String date = DateTime.now().toString();
String? luggage = "NoLuggage";
int emptySeats = 1;
String? tripDescription;
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

Map<String, String> vehicleIdNameMap = {};
String dropDownValue = '';

List<String> luggageOptions = ["NoLuggage", "Small", "Medium", "Large"];

@override
void initState() {
  //getUserVehicles();
  super.initState();
  getUserVehicles().then((map) {
    setState(() {
      vehicleIdNameMap = map;
    });
  }).catchError((error) {
    // Handle errors
    print("Error fetching vehicles: $error");
  });
  
}

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

Future<Map<String, String>> getUserVehicles() async {
  
  final SecureStorageService secureStorageService = SecureStorageService();
  final String? accessToken = await secureStorageService.read(SecureStorageService.keyAccessToken);
  final response = await HttpClient.sendRequest(HttpMethod.GET,'', '${ApiConfig.baseUrl}${ApiConfig.getVehiclesEndpoint}',authToken: accessToken);
  List<dynamic> responseBody = json.decode(response.body);
  final parsed = (responseBody).cast<Map<String, dynamic>>();
  //Map<String, String> vehicleIdNameMap = {};
  parsed.forEach((vehicle) {
    // Assuming 'model' field contains the Vehicle name
    String vehicleId = vehicle['vehicleId'];
    String vehicleName = vehicle['model'];
    vehicleIdNameMap[vehicleId] = vehicleName;
  });
    dropDownValue = vehicleIdNameMap.keys.first;
    rideDetails.vehicleId = dropDownValue;
    //dropDownValue = vehicleIdNameMap.entries.first.value;
  return vehicleIdNameMap;
} 

void _handleCreateRideError(dynamic errorMessage) {
    new ErrorHelper().showErrorMessage(context, errorMessage);
  }

Future<void> create_Driver_Ride(String startAddress, String destinationAddress, List<String> stops, String date, String vehicleId, String luggage, int emptySeats, String tripDescription) async {
  try {
        Map<String, dynamic>? response = await new DriverCreateRideService().createRide(startAddress, destinationAddress, stops, date, vehicleId, luggage, emptySeats, tripDescription);
        Logger log = new Logger();
        log.i('response service: ${response}');
        if (response is Map<String, dynamic>) {
          if (response.containsKey('error')) {
            _handleCreateRideError(response['error']);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Created Ride Successfully'),
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
                  DropdownButtonFormField<String>(
                    value: dropDownValue,
                    onChanged: (newValue) {
                      setState(() {
                        dropDownValue = newValue!; // Update the dropdown value
                        rideDetails.vehicleId = newValue; // Set the selected vehicle ID
                      });
                      
                    },
                    items: vehicleIdNameMap.entries
                        .map<DropdownMenuItem<String>>((MapEntry<String, String> entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value), 
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Select Vehicle',
                      hintText: 'Choose a vehicle',
                      // Add any desired styling or decoration here
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a vehicle';
                      }
                      return null;
                    },
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
                    onPredictionSelected: (selectedPrediction, placeId) {
                      setState(() {
                        rideDetails.startAddress = placeId; 
                        StartController.text = selectedPrediction; 
                        StartPredicitions.clear(); 
                       });
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: StopsController,
                   onSaved: (newValue) {
                    if (newValue != null) {
                      // Convert newValue to a list with a single item
                      rideDetails.stops = [newValue];
                    }
                  },
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
                    onPredictionSelected:  (selectedPrediction, placeId){
                      setState(() {
                        rideDetails.stops = [placeId]; 
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
                    onPredictionSelected:  (selectedPrediction, placeId) {
                      setState(() {
                        rideDetails.destinationAddress = placeId; 
                        DestinationController.text = selectedPrediction; 
                        DestinationPredicitions.clear(); 
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  _buildDateTimePicker('Date', rideDetails.date, (value) {
                    setState(() {
                      rideDetails.date = DateFormat('yyyy-MM-dd hh:mm a').format(value);
                    });
                  }),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                      value: luggageOptions[0],
                      onChanged: (newValue) {
                        setState(() {
                          rideDetails.luggage = newValue; // Update the luggage value
                        });
                      },
                      items: luggageOptions.map((String value) {
                       return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Luggage',
                        hintText: 'Select Luggage',
                        // Add any desired styling or decoration here
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select luggage option';
                        }
                        return null;
                      },
                    ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: '1', 
                    onChanged: (value) {
                      int? parsedValue = int.tryParse(value);
                      if (parsedValue != null && parsedValue > 0) {
                          removeError(error: emptySeatsError);
                        }
                        return;
                      },
                      validator: (value) {
                        int? parsedValue = int.tryParse(value!);
                        if (parsedValue == null || parsedValue <= 0) {
                          addError(error: emptySeatsError);
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
                    TextFormField(
                      maxLines: 3,
                      onChanged: (value) {
                        setState(() {
                          rideDetails.tripDescription = value;
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
                         create_Driver_Ride(rideDetails.startAddress!, rideDetails.destinationAddress!, rideDetails.stops, rideDetails.date, rideDetails.vehicleId!, rideDetails.luggage!, rideDetails.emptySeats, rideDetails.tripDescription!);
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