import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/vehicles/add_vehicle.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/vehicles/vehicle_details_card.dart';
import '../../services/api_services/auth.dart';

class VehiclesScreenWidget extends StatefulWidget {
  static String routeName = "/vehicle_screen";

  const VehiclesScreenWidget({Key? key}) : super(key: key);

  @override
  State<VehiclesScreenWidget> createState() => _VehiclesScreenWidgetState();
}

class _VehiclesScreenWidgetState extends State<VehiclesScreenWidget> {
  final AuthService authService = AuthService();
  List<VehicleDetails> vehicles = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Map<String, dynamic>> fetchedVehicles =
          await authService.getUserVehicles();
      setState(() {
        vehicles = fetchedVehicles
            .map((vehicleMap) => VehicleDetails(
                  vehicleId: vehicleMap['vehicleId'],
                  model: vehicleMap['model'],
                  type: vehicleMap['type'],
                  color: vehicleMap['color'],
                  year: vehicleMap['year'],
                  licensePlate: vehicleMap['licensePlate'],
                  averageKmPerLitre:
                      double.parse(vehicleMap['averageKmPerLitre'].toString()),
                  vehicleImages: List<String>.from(vehicleMap['vehicleImages']),
                ))
            .toList();
        isLoading = false;
      });
    } catch (error) {
      print('error-in-_loadVehicles---$error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshVehicles() async {
    await _loadVehicles();
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Vehicles'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshVehicles,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : vehicles.isEmpty
                ? Center(
                    child: Text(
                      'Looks like you have no vehicles, yet.',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                : ListView.builder(
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await _confirmDelete(context);
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            vehicles.removeAt(index);
                          });
                        },
                        child: VehicleDetailsCardWidget(
                          vehicleDetails: vehicles[index],
                          key: ValueKey(vehicles[index].vehicleId),
                        ),
                      );
                    },
                  ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.pushNamed(
                context, AddVehicleScreenWidget.routeName);
            if (result == true) {
              _loadVehicles();
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Text('Add a Vehicle'),
        ),
      ),
    );
  }
}
