import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/vehicles/vehicle_image_upload_row.dart';

class AddVehicleScreenWidget extends StatefulWidget {
  static String routeName = "/add_vehicle_screen";

  const AddVehicleScreenWidget({super.key});

  @override
  State<AddVehicleScreenWidget> createState() => _AddVehicleScreenWidgetState();
}

class _AddVehicleScreenWidgetState extends State<AddVehicleScreenWidget> {
  final List<DropdownMenuItem<String>> _vehicleTypes = [
    const DropdownMenuItem(value: 'Sedan', child: Text('Sedan')),
    const DropdownMenuItem(value: 'SUV', child: Text('SUV')),
    const DropdownMenuItem(value: 'Hatchback', child: Text('Hatchback')),
    const DropdownMenuItem(value: 'Truck', child: Text('Truck')),
    // Add more types as needed
  ];

  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Add a vehicle',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const VehicleImageUploadRowWidget(),
                  const SizedBox(height: 35),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Model',
                      hintText: 'e.g. Ford Focus',
                    ),
                  ),
                  const SizedBox(height: 35),
                  // Type DropdownButtonFormField
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedType,
                    items: _vehicleTypes,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedType = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 35),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Color',
                    ),
                  ),
                  const SizedBox(height: 35),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Year',
                      hintText: 'YYYY',
                    ),
                  ),
                  const SizedBox(height: 35),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Licence Plate',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle the 'Add vehicle' button press
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Add vehicle'),
            ),
          ),
        ],
      ),
    );
  }
}
