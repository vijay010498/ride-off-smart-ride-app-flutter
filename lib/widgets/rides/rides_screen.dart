import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/services/api_services/match.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/rides/rider/rider_rides.dart';

import 'driver/driver_rides.dart';

class RidesScreenWidget extends StatefulWidget {
  static String routeName = "/rides_screen";

  const RidesScreenWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RidesScreenWidgetState();
  }
}

class _RidesScreenWidgetState extends State<RidesScreenWidget> {
  final MatchService matchService = MatchService();
  List<DriverRideDetails> createdDriverRides = [];
  List<DriverRideDetails> cancelledDriverRides = [];
  List<DriverRideDetails> bookedDriverRides = [];


  List<RiderRideDetails> createdRiderRides = [];
  List<RiderRideDetails> searchingRiderRides = [];
  List<RiderRideDetails> confirmedRiderRides = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getDriverRides();
  }

  Future<void> _getDriverRides() async {
    setState(() {
      isLoading = true;
    });

    try {
      final Map<String, dynamic> userRides =
      await matchService.getRides();
      final List driverRides = userRides['driverRides'];
      final List riderRides = userRides['riderRides'];
      List<DriverRideDetails> tempCreatedDriverRides = [];
      List<DriverRideDetails> tempCancelledDriverRides = [];
      List<DriverRideDetails> tempBookedDriverRides = [];


      List<RiderRideDetails> tempCreatedRiderRides = [];
      List<RiderRideDetails> tempSearchingRiderRides = [];
      List<RiderRideDetails> tempConfirmedRiderRides = [];
      for (var driverRide in driverRides) {
        DriverRideDetails ride = DriverRideDetails(
            rideId: driverRide['rideId'],
            userId: driverRide['userId'],
            originLongitude: driverRide['originLongitude'],
            originLatitude: driverRide['originLatitude'],
            destinationLongitude: driverRide['destinationLongitude'],
            destinationLatitude: driverRide['destinationLatitude'],
            stops: driverRide['stops'],
            originAddress: driverRide['originAddress'],
            destinationAddress: driverRide['destinationAddress'],
            originPlaceId: driverRide['originPlaceId'],
            destinationPlaceId: driverRide['destinationPlaceId'],
            originUrl: driverRide['originUrl'],
            destinationUrl: driverRide['destinationUrl'],
            originName: driverRide['originName'],
            destinationName: driverRide['destinationName'],
            originPostalCode: driverRide['originPostalCode'],
            destinationPostalCode: driverRide['destinationPostalCode'],
            originCountryShortName: driverRide['originCountryShortName'],
            destinationCountryShortName:
            driverRide['destinationCountryShortName'],
            originCountryLongName: driverRide['originCountryLongName'],
            destinationCountryLongName:
            driverRide['destinationCountryLongName'],
            originProvinceShortName: driverRide['originProvinceShortName'],
            destinationProvinceShortName:
            driverRide['destinationProvinceShortName'],
            originProvinceLongName: driverRide['originProvinceLongName'],
            destinationProvinceLongName:
            driverRide['destinationProvinceLongName'],
            leaving: driverRide['leaving'],
            arrivalTime: driverRide['arrivalTime'],
            totalRideDurationInSeconds:
            driverRide['totalRideDurationInSeconds'],
            totalRideDistanceInMeters: driverRide['totalRideDistanceInMeters'],
            totalRideAverageFuelCost: driverRide['totalRideAverageFuelCost'],
            status: driverRide['status'],
            vehicleId: driverRide['vehicleId'],
            luggage: driverRide['luggage'],
            emptySeats: driverRide['emptySeats'],
            availableSeats: driverRide['availableSeats']);
        switch (ride.status) {
          case 'RIDE_CREATED':
            tempCreatedDriverRides.add(ride);
            break;
          case 'RIDE_CANCELLED':
            tempCancelledDriverRides.add(ride);
            break;
          case 'RIDE_BOOKED_FULL':
            tempBookedDriverRides.add(ride);
            break;
        }
      }

      for (var riderRide in riderRides) {
        RiderRideDetails ride = RiderRideDetails(
            rideId: riderRide['rideId'],
            userId: riderRide['userId'],
            fromLongitude: riderRide['fromLongitude'],
            fromLatitude: riderRide['fromLatitude'],
            toLongitude: riderRide['toLongitude'],
            toLatitude: riderRide['toLatitude'],
            fromAddress: riderRide['fromAddress'],
            toAddress: riderRide['toAddress'],
            fromPlaceId: riderRide['fromPlaceId'],
            fromUrl: riderRide['fromUrl'],
            toUrl: riderRide['toUrl'],
            fromName: riderRide['fromName'],
            toName: riderRide['toName'],
            fromPostalCode: riderRide['fromPostalCode'],
            toPostalCode: riderRide['toPostalCode'],
            fromCountryShortName: riderRide['fromCountryShortName'],
            toCountryShortName: riderRide['toCountryShortName'],
            fromCountryLongName: riderRide['fromCountryLongName'],
            toCountryLongName: riderRide['toCountryLongName'],
            fromProvinceShortName: riderRide['fromProvinceShortName'],
            toProvinceShortName: riderRide['toProvinceShortName'],
            fromProvinceLongName: riderRide['fromProvinceLongName'],
            toProvinceLongName: riderRide['toProvinceLongName'],
            departing: riderRide['departing'],
            totalRideDurationInSeconds: riderRide['totalRideDurationInSeconds'],
            totalRideDistanceInMeters: riderRide['totalRideDistanceInMeters'],
            seats: riderRide['seats'],
            maxPrice: riderRide['maxPrice'],
            rideDescription: riderRide['rideDescription'],
            status: riderRide['status']);

        switch (ride.status) {
          case 'RIDE_CREATED':
            tempCreatedRiderRides.add(ride);
            break;
          case 'RIDE_SEARCHING':
            tempSearchingRiderRides.add(ride);
            break;
          case 'RIDE_BOOKED_BOOKED':
            tempConfirmedRiderRides.add(ride);
            break;
        }
      }


      setState(() {
        createdDriverRides = tempCreatedDriverRides;
        cancelledDriverRides = tempCancelledDriverRides;
        bookedDriverRides = tempBookedDriverRides;

        createdRiderRides = tempCreatedRiderRides;
        searchingRiderRides = tempSearchingRiderRides;
        confirmedRiderRides = tempConfirmedRiderRides;

        isLoading = false;
      });
    } catch (error) {
      if (kDebugMode) {
        print('error-in-_getDriverRides---$error');
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshRides() async {
    await _getDriverRides();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('My Rides'),
            bottom: const TabBar(
              labelColor: Colors.deepOrange,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(
                  text: 'As Driver',
                ),
                Tab(
                  text: 'As Rider',
                )
              ],
            ),
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
            children: [
              // Replace these with your custom widgets for each tab
              Center(
                  child: DriverRidesScreenWidget(
                    tabTitles: const ['Created', 'Booked', 'Cancelled'],
                    createdRides: createdDriverRides,
                    cancelledRides: cancelledDriverRides,
                    bookedRides: bookedDriverRides,
                  )),
              Center(
                  child: RiderRidesScreenWidget(
                    tabTitles: const ['Created', 'Searching', 'Confirmed'],
                    createdRides: createdRiderRides,
                    searchingRides: searchingRiderRides,
                    confirmedRides: confirmedRiderRides,
                  )),
            ],
          ),
        ));
  }
}
