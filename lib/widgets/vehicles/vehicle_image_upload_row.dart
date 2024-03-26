import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/vehicles/vehicle_image_upload.dart';

class VehicleImageUploadRowWidget extends StatefulWidget {
  const VehicleImageUploadRowWidget({super.key});

  @override
  State<VehicleImageUploadRowWidget> createState() =>
      _VehicleImageUploadRowWidgetState();
}

class _VehicleImageUploadRowWidgetState
    extends State<VehicleImageUploadRowWidget> {
  final ScrollController _scrollController = ScrollController();

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
              (index) => const Padding(
                padding: EdgeInsets.only(right: 8),
                child: VehicleImageUploadBoxWidget(),
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
