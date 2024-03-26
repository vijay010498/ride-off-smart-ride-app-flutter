import 'package:flutter/material.dart';

class VehicleImageUploadBoxWidget extends StatelessWidget {
  const VehicleImageUploadBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          Icons.camera_alt,
          color: Colors.grey.shade600,
          size: 30,
        ),
      ),
    );
  }
}
