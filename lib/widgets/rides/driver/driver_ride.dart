import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'driver_rides.dart';

class DriverRide extends StatelessWidget {
  final DriverRideDetails ride;

  const DriverRide({Key? key, required this.ride}) : super(key: key);

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
                    ride.originName,
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
                    ride.destinationName,
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
            _infoRow('Status', '${ride.status}'),
            _infoRow('Departure', '${ride.leaving}'),
            _infoRow('Arrival', '${ride.arrivalTime}'),
            _infoRow('Distance', '${(ride.totalRideDistanceInMeters / 1000).toStringAsFixed(1)} km'),
            _infoRow('Duration', '${(ride.totalRideDurationInSeconds / 60).toStringAsFixed(1)} minutes'),
            _infoRow('Fuel Cost', '\$${ride.totalRideAverageFuelCost}'),
            _infoRow('Total Seats', '${ride.emptySeats}'),
            _infoRow('Available Seats', '${ride.availableSeats}'),
            _linkRow('Origin ', ride.originUrl),
            _linkRow('Destination ', ride.destinationUrl),
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
          Text(label, style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _linkRow(String label, String url) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500)),
            Expanded(
              child: Tooltip(
                message: url,
                child: Text(
                  _shortenUrl(url), // Display shortened URL
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  String _shortenUrl(String url) {
    const int maxDisplayLength = 20;
    if (url.length <= maxDisplayLength) {
      return url;
    }
    // Shorten URL and append ellipsis
    return '${url.substring(0, maxDisplayLength - 3)}...';
  }
}
