import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/rides/rider/rider_ride.dart';

class RiderRideDetails {
  final String rideId;
  final String userId;
  final double fromLongitude;
  final double fromLatitude;
  final double toLongitude;
  final double toLatitude;
  final String fromAddress;
  final String toAddress;
  final String fromPlaceId;
  final String fromUrl;
  final String toUrl;
  final String fromName;
  final String toName;
  final String fromPostalCode;
  final String toPostalCode;
  final String fromCountryShortName;
  final String toCountryShortName;
  final String fromCountryLongName;
  final String toCountryLongName;
  final String fromProvinceShortName;
  final String toProvinceShortName;
  final String fromProvinceLongName;
  final String toProvinceLongName;
  final String departing;
  final int totalRideDurationInSeconds;
  final int totalRideDistanceInMeters;
  final String status;
  final int seats;
  final double? maxPrice;
  final String? rideDescription; // Nullable

  RiderRideDetails(
      {required this.rideId,
      required this.status,
      required this.userId,
      required this.fromLongitude,
      required this.fromLatitude,
      required this.toLongitude,
      required this.toLatitude,
      required this.fromAddress,
      required this.toAddress,
      required this.fromPlaceId,
      required this.fromUrl,
      required this.toUrl,
      required this.fromName,
      required this.toName,
      required this.fromPostalCode,
      required this.toPostalCode,
      required this.fromCountryShortName,
      required this.toCountryShortName,
      required this.fromCountryLongName,
      required this.toCountryLongName,
      required this.fromProvinceShortName,
      required this.toProvinceShortName,
      required this.fromProvinceLongName,
      required this.toProvinceLongName,
      required this.departing,
      required this.totalRideDurationInSeconds,
      required this.totalRideDistanceInMeters,
      required this.seats,
      this.maxPrice,
      this.rideDescription});
}

class RiderRidesScreenWidget extends StatefulWidget {
  final List<String> tabTitles;
  final List<RiderRideDetails> createdRides;
  final List<RiderRideDetails> searchingRides;
  final List<RiderRideDetails> confirmedRides;

  static String routeName =
      "/rider_rides_screen"; // Static route name for navigation

  const RiderRidesScreenWidget(
      {Key? key,
      required this.tabTitles,
      required this.createdRides,
      required this.searchingRides,
      required this.confirmedRides})
      : super(key: key);

  @override
  _RiderRidesScreenWidget createState() => _RiderRidesScreenWidget();
}

class _RiderRidesScreenWidget extends State<RiderRidesScreenWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.tabTitles.length, vsync: this);
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
              children: widget.tabTitles.map((title) {
                List<RiderRideDetails> rides;
                switch (title) {
                  case 'Created':
                    rides = widget.createdRides;
                    break;
                  case 'Searching':
                    rides = widget.searchingRides;
                    break;
                  case 'Confirmed':
                    rides = widget.confirmedRides;
                    break;
                  default:
                    rides = [];
                    break;
                }
                return ListView.builder(
                  itemCount: rides.length,
                  itemBuilder: (context, index) {
                    return RiderRide(ride: rides[index]);
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
