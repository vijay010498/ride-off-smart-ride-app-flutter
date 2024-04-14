import 'package:flutter/material.dart';

class VehicleDetails {
  final String vehicleId;
  final String model;
  final String type;
  final String color;
  final String year;
  final String licensePlate;
  final double averageKmPerLitre;
  final List<String> vehicleImages;

  VehicleDetails({
    required this.vehicleId,
    required this.model,
    required this.type,
    required this.color,
    required this.year,
    required this.licensePlate,
    required this.averageKmPerLitre,
    required this.vehicleImages,
  });
}

class VehicleDetailsCardWidget extends StatelessWidget {
  final VehicleDetails vehicleDetails;

  const VehicleDetailsCardWidget({Key? key, required this.vehicleDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailText(
                  'Model: ${vehicleDetails.model}',
                  isBold: true,
                  icon: Icons.directions_car,
                ),
                _buildDetailText(
                  'Type: ${vehicleDetails.type}',
                  icon: Icons.category,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailText(
                  'Year: ${vehicleDetails.year}',
                  icon: Icons.date_range,
                ),
                _buildDetailText(
                  'Color: ${vehicleDetails.color}',
                  icon: Icons.color_lens,
                ),
              ],
            ),
            _buildDetailText(
              'License Plate: ${vehicleDetails.licensePlate}',
              icon: Icons.format_list_numbered,
            ),
            _buildDetailText(
              'Avg KM Per Litre: ${vehicleDetails.averageKmPerLitre}',
              icon: Icons.speed,
            ),
            const SizedBox(height: 10),
            const Text(
              'Images:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            _buildVehicleImages(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailText(String text, {bool isBold = false, IconData? icon}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          SizedBox(width: 5),
        ],
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleImages(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: vehicleDetails.vehicleImages
          .map((imageUrl) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BigImageScreen(imageUrl: imageUrl),
            ),
          );
        },
        child: Image.network(
          imageUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
      ))
          .toList(),
    );
  }
}

class BigImageScreen extends StatelessWidget {
  final String imageUrl;

  const BigImageScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
