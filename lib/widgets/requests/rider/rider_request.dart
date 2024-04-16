import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/services/api_services/match.dart';
import 'package:ride_off_smart_ride_app_flutter/widgets/requests/rider/rider_requests.dart';

import '../../../helpers/errorhelper.dart';

class RiderRequest extends StatelessWidget {
  final RiderRequestDetails request;
  final String statustext;
  final VoidCallback onAction;

  const RiderRequest(
      {Key? key,
      required this.request,
      required this.statustext,
      required this.onAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4.0,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    request.riderRideId['fromName'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green[700],
                    ),
                  ),
                ),
                Icon(Icons.arrow_right_alt, color: Colors.grey[700]),
                Expanded(
                  child: Text(
                    request.riderRideId['toName'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red[700],
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1.5),
            _infoRow('Request ID', request.requestId),
            _infoRow('Driver Origin', request.driverRideId['originName']),
            _infoRow('Driver Destination', request.driverRideId['destinationName']),
            _infoRow('Luggage', request.driverRideId['luggage']),
            _infoRow('Total Seats', request.driverRideId['emptySeats']),
            _infoRow('Empty Seats', request.driverRideId['emptySeats']),
            _infoRow('Status', statustext),
            _infoRow('Driver Price', '\$${request.priceByDriver}'),
            if (request.negotiatedPrice != null)
              _infoRow('Your Price', '\$${request.negotiatedPrice}'),
            if (request.acceptedPrice != null)
              _infoRow('Confirmed Price', '\$${request.acceptedPrice}'),
            if (request.canNegotiate) _priceInputField(context, request),
            const Divider(height: 20, thickness: 1.5),
            if (request.canAccept)
              _actionButton('Accept', Colors.green, () async {
                await _handleAccept(context);
              }),
            if (request.canDecline)
              _actionButton('Decline', Colors.red, () async {
                await _handleDecline(context);
              }),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: Colors.grey[800], fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _actionButton(String text, Color color, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: color),
        child: Text(text),
      ),
    );
  }

  Widget _priceInputField(BuildContext context, RiderRequestDetails request) {
    TextEditingController _controller = TextEditingController();
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter Your Price (Only Once Allowed)',
              suffixIcon: IconButton(
                icon: const Icon(Icons.send, color: Colors.green),
                onPressed: () async {
                  if (_validatePrice(_controller.text)) {
                    showLoadingDialog(context, 'Negotiating Price');
                    final MatchService matchService = MatchService();

                    final priceSent = await matchService.driverGivesPrice(
                        requestId: request.requestId,
                        price: double.parse(_controller.text));

                    if (priceSent) {
                      onAction();
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pop();
                      ErrorHelper().showErrorMessage(
                          context, 'Server Error, Please try again later');
                    }
                    _controller.clear();
                  } else {
                    ErrorHelper().showErrorMessage(context, 'Invalid Price');
                  }
                },
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
      ],
    );
  }

  bool _validatePrice(String text) {
    if (text.isEmpty) return false;
    final double? price = double.tryParse(text);
    return price != null && price > 0;
  }

  Future<void> _handleAccept(BuildContext context) async {
    showLoadingDialog(context, 'Accepting Request');
    final MatchService matchService = MatchService();

    try {
      final requestAccepted =
          await matchService.riderAcceptsRequest(requestId: request.requestId);

      Navigator.of(context)
          .pop(); // Close the loading dialog immediately after API call

      if (requestAccepted) {
        onAction(); // Refresh the parent widget or handle success
      } else {
        ErrorHelper()
            .showErrorMessage(context, 'Server Error, Please try again later');
      }
    } catch (error) {
      Navigator.of(context)
          .pop(); // Ensure the dialog is closed in case of error
      ErrorHelper().showErrorMessage(context, 'An error occurred: $error');
    }
  }

  Future<void> _handleDecline(BuildContext context) async {
    showLoadingDialog(context, 'Declining Request');
    final MatchService matchService = MatchService();

    try {
      final requestDeclined =
          await matchService.riderDeclinesRequest(requestId: request.requestId);

      Navigator.of(context)
          .pop(); // Close the loading dialog immediately after API call

      if (requestDeclined) {
        onAction(); // Refresh the parent widget or handle success
      } else {
        ErrorHelper()
            .showErrorMessage(context, 'Server Error, Please try again later');
      }
    } catch (error) {
      Navigator.of(context)
          .pop(); // Ensure the dialog is closed in case of error
      ErrorHelper().showErrorMessage(context, 'An error occurred: $error');
    }
  }

  void showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: <Widget>[
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(message),
            ],
          ),
        );
      },
    );
  }
}
