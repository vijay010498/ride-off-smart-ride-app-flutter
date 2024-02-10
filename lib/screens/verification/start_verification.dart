import 'package:flutter/material.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/verification/Id_capture/capture_identity.dart';
import 'package:ride_off_smart_ride_app_flutter/screens/verification/complete_verification.dart';
import 'package:selfie_liveness/selfie_liveness.dart';

class StartVerification extends StatefulWidget {
  static String routeName = "/start_verification";

  const StartVerification({super.key});

  @override
  State<StartVerification> createState() {
    return _StartVerificationState();
  }
}


class _StartVerificationState extends State<StartVerification> {
  bool selfieCaptured = false;
  bool photoIdCaptured = false;
  String? selfieImagePath;
  String? photoIdImagePath;

  @override
  Widget build(BuildContext context) {
    bool isVerificationComplete = selfieCaptured && photoIdCaptured;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _captureSelfie(context);
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Capture Selfie'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                  ),
                  Visibility(
                    visible: selfieCaptured,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.check, size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _capturePhotoId(context);
                    },
                    icon: const Icon(Icons.credit_card),
                    label: const Text('Capture Photo ID'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                  ),
                  Visibility(
                    visible: photoIdCaptured,
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.check, size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: isVerificationComplete ? () => _completeVerification(context) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isVerificationComplete ? Colors.green : Colors.grey,
                ),
                child: const Text('Complete Verification'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _captureSelfie(BuildContext context) async {
    try {
      final imagePath = await SelfieLiveness.detectLiveness(
        poweredBy: "Powered By Ride Off",
        assetLogo: "",
        compressQualityandroid: 90,
        compressQualityiOS: 90
      );
      setState(() {
        selfieImagePath = imagePath;
        selfieCaptured = true;
      });
    } catch (e) {
      print('Selfie capture failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selfie capture failed: $e'),
        ),
      );
    }
  }

  Future<void> _capturePhotoId(BuildContext context) async {
    try {
      final imagePath = await showCapture(
          context: context, title: "Scan ID", hideIdWidget: false);
      setState(() {
        photoIdImagePath = imagePath?.path;
        photoIdCaptured = true;
      });
    } catch (e) {
      print('Photo ID capture failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Photo ID capture failed: $e'),
        ),
      );
    }
  }

  void _completeVerification(BuildContext context) {
    // Your logic to complete the verification process
    Map<String, String?> arguments = {
      'selfieImagePath': selfieImagePath,
      'photoIdImagePath': photoIdImagePath
    };
    Navigator.pushNamed(context, CompleteVerification.routeName, arguments:arguments);
  }
}


