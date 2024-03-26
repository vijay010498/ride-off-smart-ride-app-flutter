import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/components/autocomplete_prediction.dart';

class PredictionListContainer extends StatelessWidget {
  final List<AutoCompletePrediction> predictions;
  final Function(String) onPredictionSelected;

  PredictionListContainer({
    required this.predictions,
    required this.onPredictionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      height: 200,
      child: ListView.builder(
        itemCount: predictions.length,
        itemBuilder: (context, index) {
          final prediction = predictions[index];
          return ListTile(
            title: Text(prediction.description ?? ''),
            onTap: () {
              onPredictionSelected(prediction.description ?? '');
            },
          );
        },
      ),
    );
  }
}
