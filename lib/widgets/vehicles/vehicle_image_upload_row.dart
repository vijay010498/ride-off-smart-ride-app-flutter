import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/vehicles/vehicle_image_upload_box.dart';

class VehicleImageUploadRowWidget extends StatefulWidget {
  final Function(List<File>) onImagesUpdated;

  const VehicleImageUploadRowWidget({Key? key, required this.onImagesUpdated}) : super(key: key);

  @override
  State<VehicleImageUploadRowWidget> createState() => _VehicleImageUploadRowWidgetState();
}

class _VehicleImageUploadRowWidgetState
    extends State<VehicleImageUploadRowWidget> {
  final List<File> _pickedImages = [];
  final ScrollController _scrollController = ScrollController();

  void _handleImagePicked(File image) {
    setState(() {
      _pickedImages.add(image);
    });
    widget.onImagesUpdated(_pickedImages); // Notify the parent widget
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _animateScroll());
  }

  void _animateScroll() {
    final double startScrollPosition =
        _scrollController.position.minScrollExtent;
    const double offset = 30;
    _scrollController
        .animateTo(startScrollPosition + offset,
            duration: const Duration(milliseconds: 500), curve: Curves.easeOut)
        .then((_) {
      _scrollController.animateTo(startScrollPosition,
          duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Vehicle Images',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(
              5,
                  (index) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: VehicleImageUploadBoxWidget(onImagePicked: _handleImagePicked), // Modify this line
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
