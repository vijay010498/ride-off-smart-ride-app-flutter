import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VehicleImageUploadBoxWidget extends StatefulWidget {
  final Function(File) onImagePicked;

  const VehicleImageUploadBoxWidget({Key? key, required this.onImagePicked}) : super(key: key);

  @override
  State<VehicleImageUploadBoxWidget> createState() => _VehicleImageUploadBoxWidgetState();
}

class _VehicleImageUploadBoxWidgetState extends State<VehicleImageUploadBoxWidget> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
      widget.onImagePicked(_image!); // Notify the parent widget about the picked image
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Choose from gallery'),
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Take a photo'),
                    onTap: () {
                      _pickImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
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
        child: _image != null
            ? Image.file(
          _image!,
          width: 90,
          height: 90,
          fit: BoxFit.cover,
        )
            : Icon(
          Icons.camera_alt,
          color: Colors.grey.shade600,
          size: 30,
        ),
      ),
    );
  }
}
