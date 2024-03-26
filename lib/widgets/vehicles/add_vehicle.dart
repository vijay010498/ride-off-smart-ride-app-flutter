import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/services/api_services/auth.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/utils/upper_case_text_formatter.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/vehicles/vehicle_image_upload_row.dart';

class AddVehicleScreenWidget extends StatefulWidget {
  static String routeName = "/add_vehicle_screen";

  const AddVehicleScreenWidget({super.key});

  @override
  State<AddVehicleScreenWidget> createState() => _AddVehicleScreenWidgetState();
}

class _AddVehicleScreenWidgetState extends State<AddVehicleScreenWidget> {
  List<File> _vehicleImages = [];
  final _formKey = GlobalKey<FormState>();
  List<DropdownMenuItem<String>> _vehicleTypes = [];
  String? _selectedType;

  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _licensePlateController = TextEditingController();
  final TextEditingController _avgKMController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchVehicleTypes();
  }

  @override
  void dispose() {
    _modelController.dispose();
    _colorController.dispose();
    _yearController.dispose();
    _licensePlateController.dispose();
    _avgKMController.dispose();
    super.dispose();
  }

  Future<void> _fetchVehicleTypes() async {
    try {
      final vehicleTypes = await AuthService().getVehicleTypes();
      setState(() {
        _vehicleTypes = vehicleTypes.map<DropdownMenuItem<String>>((type) {
          return DropdownMenuItem(value: type, child: Text(type));
        }).toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print("Failed to fetch vehicle types: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vehicle'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add a vehicle',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              VehicleImageUploadRowWidget(
                onImagesUpdated: (List<File> images) {
                  setState(() {
                    _vehicleImages = images;
                  });
                },
              ),
              const SizedBox(height: 35),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(
                  labelText: 'Model',
                  hintText: 'e.g., Honda Accord V6',
                ),
                maxLength: 20,
                inputFormatters: [UpperCaseTextFormatter()],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the model';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 35),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                value: _selectedType,
                items: _vehicleTypes,
                onChanged: (value) => setState(() => _selectedType = value),
                validator: (value) =>
                value == null ? 'Please select a type' : null,
              ),
              const SizedBox(height: 35),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(
                  labelText: 'Color',
                  hintText: 'e.g., Grey',
                ),
                maxLength: 20,
                inputFormatters: [UpperCaseTextFormatter()],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the color';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 35),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(
                  labelText: 'Year',
                  hintText: '2017',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the year';
                  } else if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                    return 'Enter a valid 4-digit year';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 35),
              TextFormField(
                controller: _licensePlateController,
                decoration: const InputDecoration(
                  labelText: 'Licence Plate',
                  hintText: 'e.g., FGMN 805',
                ),
                textCapitalization: TextCapitalization.characters,
                // Ensures all letters are capitalized as the user types
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the licence plate';
                  } else if (!RegExp(r'^[A-Z]{4}\s\d{3}$').hasMatch(value)) {
                    return 'Enter a valid licence plate (e.g., FGMN 805)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 35),
              TextFormField(
                controller: _avgKMController,
                decoration: const InputDecoration(
                  labelText: 'AVG Km Per Litre Gas',
                  hintText: 'e.g., 15',
                  helperText: 'Helps Optimize Your Ride Matches',
                ),
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter AVG Km Per Litre Gas';
                  } else if (double.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 35),
              ElevatedButton(
                onPressed: () async {
                  final AuthService authService = AuthService();
                  if (_formKey.currentState!.validate()) {
                    showLoadingDialog(context);
                    final vehicleCreationSuccess = await authService.createNewVehicle(
                        _vehicleImages,
                        _modelController.text,
                        _selectedType!,
                        _colorController.text,
                        _yearController.text,
                        _licensePlateController.text,
                        _avgKMController.text);

                    Navigator.of(context).pop();
                    if(vehicleCreationSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vehicle added successfully')),
                      );
                      // Navigate back to previous page
                      Navigator.of(context).pop();
                    } else  {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Server Error, Please try again later')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('Add vehicle'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Creating Vehicle"),
            ],
          ),
        );
      },
    );
  }
}
