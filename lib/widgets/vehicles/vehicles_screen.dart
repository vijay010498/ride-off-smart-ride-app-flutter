import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/vehicles/add_vehicle.dart';

class VehiclesScreenWidget extends StatelessWidget {
  static String routeName = "/vehicle_screen";
  const VehiclesScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Vehicles'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 8,
            ),
            Text(
              'Looks like you have no vehicles, yet.',
              style: Theme.of(context).textTheme.titleMedium,
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, AddVehicleScreenWidget.routeName);
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
