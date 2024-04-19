import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/requests/driver/driver_request.dart';

class DriverRequestDetails {
  final String requestId;
  final String driverId;
  final dynamic riderRideId;
  final dynamic driverRideId;
  final String status;
  final String rideRequestDetails;
  final dynamic driverStartingPrice;
  final dynamic riderRequestingPrice;
  final dynamic acceptedPrice;
  final bool canDecline;
  final bool canAccept;
  final bool shouldGivePrice;

  DriverRequestDetails({
    required this.requestId,
    required this.driverId,
    required this.riderRideId,
    required this.driverRideId,
    required this.status,
    required this.rideRequestDetails,
    required this.canDecline,
    required this.canAccept,
    required this.shouldGivePrice,
    this.driverStartingPrice,
    this.riderRequestingPrice,
    this.acceptedPrice
  });
}

class DriverRequestsScreenWidget extends StatefulWidget {
  final List<String> tabTitles;
  final List<DriverRequestDetails> needActionRequests;
  final List<DriverRequestDetails> acceptedRequests;
  final List<DriverRequestDetails> waitingRequests;
  final List<DriverRequestDetails> allRequests;
  final VoidCallback refreshRequests;

  const DriverRequestsScreenWidget(
      {Key? key,
      required this.tabTitles,
      required this.needActionRequests,
      required this.acceptedRequests,
      required this.waitingRequests,
      required this.allRequests,
      required this.refreshRequests})
      : super(key: key);

  @override
  _DriverRequestsScreenWidget createState() => _DriverRequestsScreenWidget();
}

class _DriverRequestsScreenWidget extends State<DriverRequestsScreenWidget>
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
                List<DriverRequestDetails> driverRequests;
                switch (title) {
                  case 'ACTION':
                    driverRequests = widget.needActionRequests;
                    break;
                  case 'ACCEPTED':
                    driverRequests = widget.acceptedRequests;
                    break;
                  case 'WAITING':
                    driverRequests = widget.waitingRequests;
                    break;
                  case 'ALL':
                    driverRequests = widget.allRequests;
                    break;
                  default:
                    driverRequests = [];
                    break;
                }
                return ListView.builder(
                  itemCount: driverRequests.length,
                  itemBuilder: (context, index) {
                    String statustext;
                    switch (driverRequests[index].status) {
                      case 'DRIVER_RIDE_REQUEST_WAITING_FOR_DRIVER_RESPONSE':
                        statustext = 'AWAITING_YOUR_RESPONSE';
                        break;
                      case 'DRIVER_RIDE_REQUEST_ACCEPTED_BY_RIDER':
                        statustext = 'ACCEPTED_BY_RIDER';
                        break;
                      case 'DRIVER_RIDE_REQUEST_ACCEPTED_BY_DRIVER':
                        statustext = 'ACCEPTED_BY_DRIVER(YOU)';
                        break;
                      case 'DRIVER_RIDE_REQUEST_WAITING_FOR_RIDER_RESPONSE':
                        statustext = 'WAITING_RIDER_RESPONSE';
                        break;
                      case 'DRIVER_RIDE_REQUEST_DECLINED_BY_DRIVER':
                        statustext = 'DECLINED_BY_DRIVER(YOU)';
                        break;
                      case 'DRIVER_RIDE_REQUEST_DECLINED_BY_RIDER':
                        statustext = 'DECLINED_BY_RIDER';
                        break;
                      default:
                        statustext = 'UNKNOWN';
                    }
                    return DriverRequest(
                      request: driverRequests[index],
                      statustext: statustext,
                      onAction: widget.refreshRequests,
                    );
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
