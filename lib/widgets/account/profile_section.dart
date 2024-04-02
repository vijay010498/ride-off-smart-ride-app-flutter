import 'package:flutter/material.dart';

class ProfileSectionWidget extends StatelessWidget {
  const ProfileSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
      ),
      title: const Text('View your profile'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Handle the tap
      },
    );
  }
}
