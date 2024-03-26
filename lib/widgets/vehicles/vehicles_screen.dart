import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/vehicles/add_vehicle.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/vehicles/vehicle_details_card.dart';

import '../../services/api_services/auth.dart';

class VehiclesScreenWidget extends StatefulWidget {
  static String routeName = "/vehicle_screen";

  const VehiclesScreenWidget({super.key});

  @override
  State<VehiclesScreenWidget> createState() {
    return _VehiclesScreenWidgetState();
  }
}

class _VehiclesScreenWidgetState extends State<VehiclesScreenWidget> {
  final AuthService authService = AuthService();
  List<Map<String, dynamic>> vehicles = [];

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    try {
      List<Map<String, dynamic>> fetchedVehicles =
          await authService.getUserVehicles();
      setState(() {
        vehicles = fetchedVehicles;
      });

    } catch (error) {
      print('error-in-_loadVehicles---$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Vehicles'),
        centerTitle: true,
      ),
      body: vehicles.isEmpty
          ? Center(
              child: Text(
                'Looks like you have no vehicles, yet.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          : ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                return VehicleDetailsCardWidget(
                  vehicleDetails: vehicles[index],
                  key: ValueKey(vehicles[index]['vehicleId']),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.pushNamed(context, AddVehicleScreenWidget.routeName);
            if (result == true) {
              _loadVehicles();
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Text('Add a vehicles'),
        ),
      ),
    );
  }
}
