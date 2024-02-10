import 'dart:io';

import 'package:flutter/material.dart';

class CompleteVerification extends StatelessWidget {
  static String routeName = "/complete_verification";

  const CompleteVerification({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, String?> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
    String selfieImagePath = arguments['selfieImagePath']!;
    String photoIdImagePath = arguments['photoIdImagePath']!;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Verification Started'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.file(File(selfieImagePath)), // Display selfie image
              Image.file(File(photoIdImagePath)), // Display photo ID image
            ],
          ),
        ));
  }
}
