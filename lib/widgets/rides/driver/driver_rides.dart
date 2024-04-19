import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/rides/driver/driver_ride.dart';

class DriverRideDetails {
  final String rideId;
  final String userId;
  final double originLongitude;
  final double originLatitude;
  final double destinationLongitude;
  final double destinationLatitude;
  final List<dynamic> stops;
  final String originAddress;
  final String destinationAddress;
  final String originPlaceId;
  final String destinationPlaceId;
  final String originUrl;
  final String destinationUrl;
  final String originName;
  final String destinationName;
  final String? originPostalCode;
  final String? destinationPostalCode;
  final String originCountryShortName;
  final String destinationCountryShortName;
  final String originCountryLongName;
  final String destinationCountryLongName;
  final String originProvinceShortName;
  final String destinationProvinceShortName;
  final String originProvinceLongName;
  final String destinationProvinceLongName;
  final String leaving;
  final String arrivalTime;
  final int totalRideDurationInSeconds;
  final int totalRideDistanceInMeters;
  final int totalRideAverageFuelCost;
  final String status;
  final Map<String, dynamic> vehicleId;
  final String luggage;
  final int emptySeats;
  final int availableSeats;

  DriverRideDetails({
    required this.rideId,
    required this.userId,
    required this.originLongitude,
    required this.originLatitude,
    required this.destinationLongitude,
    required this.destinationLatitude,
    required this.stops,
    required this.originAddress,
    required this.destinationAddress,
    required this.originPlaceId,
    required this.destinationPlaceId,
    required this.originUrl,
    required this.destinationUrl,
    required this.originName,
    required this.destinationName,
    this.originPostalCode,
    this.destinationPostalCode,
    required this.originCountryShortName,
    required this.destinationCountryShortName,
    required this.originCountryLongName,
    required this.destinationCountryLongName,
    required this.originProvinceShortName,
    required this.destinationProvinceShortName,
    required this.originProvinceLongName,
    required this.destinationProvinceLongName,
    required this.leaving,
    required this.arrivalTime,
    required this.totalRideDurationInSeconds,
    required this.totalRideDistanceInMeters,
    required this.totalRideAverageFuelCost,
    required this.status,
    required this.vehicleId,
    required this.luggage,
    required this.emptySeats,
    required this.availableSeats,
  });
}

class DriverRidesScreenWidget extends StatefulWidget {
  final List<String> tabTitles;
  final List<DriverRideDetails> createdRides;
  final List<DriverRideDetails> bookedRides;
  final List<DriverRideDetails> cancelledRides;

  const DriverRidesScreenWidget({
    Key? key,
    required this.tabTitles,
    required this.createdRides,
    required this.bookedRides,
    required this.cancelledRides,
  }) : super(key: key);

  @override
  _DriverRidesScreenWidgetState createState() => _DriverRidesScreenWidgetState();
}

class _DriverRidesScreenWidgetState extends State<DriverRidesScreenWidget> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Material(
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.amber,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.blue,
              tabs: widget.tabTitles.map((title) => Tab(text: title)).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: widget.tabTitles
                  .map((title) {
                List<DriverRideDetails> rides;
                switch (title) {
                  case 'Created':
                    rides = widget.createdRides;
                    break;
                  case 'Booked':
                    rides = widget.bookedRides;
                    break;
                  case 'Cancelled':
                    rides = widget.cancelledRides;
                    break;
                  default:
                    rides = [];
                    break;
                }
                return ListView.builder(
                  itemCount: rides.length,
                  itemBuilder: (context, index) {
                    return DriverRide(ride: rides[index]);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

