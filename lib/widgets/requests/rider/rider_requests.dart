import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/requests/driver/driver_request.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/requests/rider/rider_request.dart';

class RiderRequestDetails {
  final String requestId;
  final String riderId;
  final dynamic driverRideId;
  final dynamic riderRideId;
  final String driverRideRequestId;
  final String status;
  final dynamic rideRequestDetails;
  final bool canDecline;
  final bool canAccept;
  final bool canNegotiate;
  final dynamic acceptedPrice;
  final dynamic priceByDriver;
  final dynamic negotiatedPrice;

  RiderRequestDetails( {
      required this.requestId,
      required this.riderId,
      required this.driverRideId,
      required this.riderRideId,
      required this.driverRideRequestId,
      required this.status,
      required this.rideRequestDetails,
      required this.canDecline,
      required this.canAccept,
      required this.canNegotiate,
      this.acceptedPrice,
      this.priceByDriver,
      this.negotiatedPrice});
}

class RiderRequestsScreenWidget extends StatefulWidget {
  final List<String> tabTitles;
  final List<RiderRequestDetails> needActionRequests;
  final List<RiderRequestDetails> acceptedRequests;
  final List<RiderRequestDetails> waitingRequests;
  final List<RiderRequestDetails> allRequests;
  final VoidCallback refreshRequests;

  const RiderRequestsScreenWidget(
      {Key? key,
      required this.tabTitles,
      required this.needActionRequests,
      required this.acceptedRequests,
      required this.waitingRequests,
      required this.allRequests,
      required this.refreshRequests})
      : super(key: key);

  @override
  _RiderRequestsScreenWidget createState() => _RiderRequestsScreenWidget();
}

class _RiderRequestsScreenWidget extends State<RiderRequestsScreenWidget>
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
                List<RiderRequestDetails> riderRequests;
                switch (title) {
                  case 'ACTION':
                    riderRequests = widget.needActionRequests;
                    break;
                  case 'ACCEPTED':
                    riderRequests = widget.acceptedRequests;
                    break;
                  case 'WAITING':
                    riderRequests = widget.waitingRequests;
                    break;
                  case 'ALL':
                    riderRequests = widget.allRequests;
                    break;
                  default:
                    riderRequests = [];
                    break;
                }
                return ListView.builder(
                  itemCount: riderRequests.length,
                  itemBuilder: (context, index) {
                    String statusText;
                    switch (riderRequests[index].status) {
                      case 'RIDER_RIDE_REQUEST_WAITING_FOR_RIDER_RESPONSE':
                        statusText = 'AWAITING_YOUR_RESPONSE';
                        break;
                      case 'RIDER_RIDE_REQUEST_DECLINED_BY_RIDER':
                        statusText = 'DECLINED_BY_RIDER(YOU)';
                        break;
                      case 'RIDER_RIDE_REQUEST_DECLINED_BY_DRIVER':
                        statusText = 'DECLINED_BY_DRIVER';
                        break;
                      case 'RIDER_RIDE_REQUEST_WAITING_FOR_DRIVER_RESPONSE':
                        statusText = 'WAITING_DRIVER_RESPONSE';
                        break;
                      case 'RIDER_RIDE_REQUEST_ACCEPTED_BY_DRIVER':
                        statusText = 'ACCEPTED_BY_DRIVER';
                        break;
                      case 'RIDER_RIDE_REQUEST_ACCEPTED_BY_RIDER':
                        statusText = 'ACCEPTED_BY_RIDER(YOU)';
                        break;
                      default:
                        statusText = 'UNKNOWN';
                    }
                    return RiderRequest(
                      request: riderRequests[index],
                      statustext: statusText,
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
