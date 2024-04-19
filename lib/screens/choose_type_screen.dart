import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/driver/create_ride_form.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/rider/find_ride.dart';
// import 'package:ride_off_smart_ride_app_flutter/screens/driver/create_ride_form.dart';
// import 'package:ride_off_smart_ride_app_flutter/screens/rider/find_ride.dart';

class ChooseOptionScreen extends StatelessWidget {
  static String routeName = "/choose_option_screen";
  const ChooseOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: const Text("Create Rides"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),

      child: Center(
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CreateRideScreen.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 180.0),
                  ),
                  child: const Text(
                    'Post a Ride',
                    style: TextStyle(fontSize: 20.0)
                  ),
                ),
              const SizedBox(height: 40),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, FindPassengerRide.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 180.0),
                  ),
                  child: const Text(
                    'Find a ride',
                    style: TextStyle(fontSize: 20.0)),
                ),

            ],
          ),
        ),
      ),
      ),
    );
  }
}

// class RideDetailsScreen extends StatefulWidget {
//   final String role;

//   RideDetailsScreen({required this.role});

//   @override
//   _RideDetailsScreenState createState() => _RideDetailsScreenState();
// }

// class _RideDetailsScreenState extends State<RideDetailsScreen> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${widget.role} Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // ... (Rest of the content as per previous example)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Rest of the code (RideDetails class, _buildTextField, _buildStopsList, _buildDateTimePicker) remains unchanged.
