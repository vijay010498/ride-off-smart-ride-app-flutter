import 'package:flutter/material.dart';

class VehicleDetailsCardWidget extends StatelessWidget {
  final Map<String, dynamic> vehicleDetails;

  const VehicleDetailsCardWidget({required Key key, required this.vehicleDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Model: ${vehicleDetails['model']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text('Type: ${vehicleDetails['type']}'),
            const SizedBox(height: 5),
            Text('Color: ${vehicleDetails['color']}'),
            const SizedBox(height: 5),
            Text('Year: ${vehicleDetails['year']}'),
            const SizedBox(height: 5),
            Text('License Plate: ${vehicleDetails['licensePlate']}'),
            const SizedBox(height: 5),
            Text('Average KM Per Litre: ${vehicleDetails['averageKmPerLitre']}'),
            const SizedBox(height: 5),
            const Text('Images:'),
            const SizedBox(height: 5),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                vehicleDetails['vehicleImages'].length,
                    (index) => Image.network(
                  vehicleDetails['vehicleImages'][index],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
