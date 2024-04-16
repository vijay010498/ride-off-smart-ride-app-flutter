import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/requests/driver/driver_requests.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/requests/rider/rider_requests.dart';

import '../../services/api_services/match.dart';

class RequestsScreenWidget extends StatefulWidget {
  static String routeName = "/requests_screen";

  const RequestsScreenWidget({Key? key}) : super(key: key);

  @override
  _RequestsScreenWidgetState createState() => _RequestsScreenWidgetState();
}

class _RequestsScreenWidgetState extends State<RequestsScreenWidget> {
  final MatchService matchService = MatchService();
  List<DriverRequestDetails> needActionDriverRequests = [];
  List<DriverRequestDetails> acceptedDriverRequests = [];
  List<DriverRequestDetails> waitingDriverRequests = [];
  List<DriverRequestDetails> allDriverRequests = [];


  List<RiderRequestDetails> needActionRiderRequests = [];
  List<RiderRequestDetails> acceptedRiderRequests = [];
  List<RiderRequestDetails> waitingRiderRequests = [];
  List<RiderRequestDetails> allRiderRequests = [];
  Timer? _timer;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getRequests();
    _timer = Timer.periodic(
        Duration(seconds: 60), (Timer t) => _getRequests());
  }

  @override
  void dispose() {
    _timer
        ?.cancel(); // Make sure to cancel the timer when the widget is disposed.
    super.dispose();
  }

  Future<void> _getRequests() async {
    setState(() {
      isLoading = true;
    });

    try {
      final Map<String, dynamic> userRequests = await matchService
          .getRequests();
      final List driverRequests = userRequests['driverRequests'];
      final List riderRequests = userRequests['riderRequests'];

      List<DriverRequestDetails> tempNeedActionDriverRequests = [];
      List<DriverRequestDetails> tempAcceptedDriverRequests = [];
      List<DriverRequestDetails> tempWaitingDriverRequests = [];
      List<DriverRequestDetails> tempAllDriverRequests = [];


      List<RiderRequestDetails> tempNeedActionRiderRequests = [];
      List<RiderRequestDetails> tempAcceptedRiderRequests = [];
      List<RiderRequestDetails> tempWaitingRiderRequests = [];
      List<RiderRequestDetails> tempAllRiderRequests = [];

      for (var driverRequest in driverRequests) {
        DriverRequestDetails request = DriverRequestDetails(
            requestId: driverRequest['requestId'],
            driverId: driverRequest['driverId'],
            riderRideId: driverRequest['riderRideId'],
            driverRideId: driverRequest['driverRideId'],
            status: driverRequest['status'],
            rideRequestDetails: driverRequest['rideRequestDetails'],
            canDecline: driverRequest['canDecline'],
            canAccept: driverRequest['canAccept'],
            driverStartingPrice: driverRequest['driverStartingPrice'],
            riderRequestingPrice: driverRequest['riderRequestingPrice'],
            acceptedPrice: driverRequest['acceptedPrice'],
            shouldGivePrice: driverRequest['shouldGivePrice']);

        switch (request.status) {
          case 'DRIVER_RIDE_REQUEST_WAITING_FOR_DRIVER_RESPONSE':
            tempNeedActionDriverRequests.add(request);
            break;
          case 'DRIVER_RIDE_REQUEST_ACCEPTED_BY_RIDER':
          case 'DRIVER_RIDE_REQUEST_ACCEPTED_BY_DRIVER':
            tempAcceptedDriverRequests.add(request);
            break;
          case 'DRIVER_RIDE_REQUEST_WAITING_FOR_RIDER_RESPONSE':
            tempWaitingDriverRequests.add(request);
            break;
          default:
            tempAllDriverRequests.add(request);
            break;
        }
      }


      for (var riderRequest in riderRequests) {
        RiderRequestDetails request = RiderRequestDetails(
            requestId : riderRequest['requestId'],
            riderId: riderRequest['riderId'],
            driverRideId: riderRequest['driverRideId']['rideId'],
            riderRideId: riderRequest['riderRideId']['rideId'],
            driverRideRequestId: riderRequest['driverRideRequestId'],
            status: riderRequest['status'],
            rideRequestDetails: riderRequest['rideRequestDetails'],
            canDecline: riderRequest['canDecline'],
            canAccept: riderRequest['canAccept'],
            canNegotiate: riderRequest['canNegotiate'],
            acceptedPrice: riderRequest['acceptedPrice'],
            priceByDriver: riderRequest['priceByDriver'],
            negotiatedPrice: riderRequest['negotiatedPrice']);

        switch (request.status) {
          case 'RIDER_RIDE_REQUEST_WAITING_FOR_RIDER_RESPONSE':
            tempNeedActionRiderRequests.add(request);
            break;
          case 'RIDER_RIDE_REQUEST_ACCEPTED_BY_RIDER':
          case 'RIDER_RIDE_REQUEST_ACCEPTED_BY_DRIVER':
            tempAcceptedRiderRequests.add(request);
            break;
          case 'RIDER_RIDE_REQUEST_WAITING_FOR_DRIVER_RESPONSE':
            tempWaitingRiderRequests.add(request);
            break;
          default:
            tempAllRiderRequests.add(request);
            break;
        }
      }

      setState(() {
        needActionDriverRequests = tempNeedActionDriverRequests;
        acceptedDriverRequests = tempAcceptedDriverRequests;
        waitingDriverRequests = tempWaitingDriverRequests;
        allDriverRequests = tempAllDriverRequests;


        needActionRiderRequests = tempNeedActionRiderRequests;
        acceptedRiderRequests = tempAcceptedRiderRequests;
        waitingRiderRequests = tempWaitingRiderRequests;
        allRiderRequests = tempAllRiderRequests;
        isLoading = false;
      });
    } catch (error) {
      if (kDebugMode) {
        print('error-in-_getDriverRequests---$error');
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('My Requests'),
            bottom: const TabBar(
              labelColor: Colors.deepOrange,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(text: 'As Driver'),
                Tab(text: 'As Rider'),
              ],
            ),
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
            children: [
              Center(
                  child: DriverRequestsScreenWidget(
                    tabTitles: const ['ACTION', 'ACCEPTED', 'WAITING', 'ALL'],
                    needActionRequests: needActionDriverRequests,
                    acceptedRequests: acceptedDriverRequests,
                    waitingRequests: waitingDriverRequests,
                    allRequests: allDriverRequests,
                    refreshRequests: _getRequests,
                  )),
              Center(
                  child: RiderRequestsScreenWidget(
                    tabTitles: const ['ACTION', 'ACCEPTED', 'WAITING', 'ALL'],
                    needActionRequests: needActionRiderRequests,
                    acceptedRequests: acceptedRiderRequests,
                    waitingRequests: waitingRiderRequests,
                    allRequests: allRiderRequests,
                    refreshRequests: _getRequests,
                  )),
            ],
          ),
        ));
  }
}
