import 'package:flutter/material.dart';

class SettingsItemWidget extends StatelessWidget {
  final String title;
  final void Function()? onTap;

  const SettingsItemWidget({Key? key, required this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap != null
          ? () {
              if (onTap != null) {
                onTap!(); // Call the onTap function
              }
            }
          : null,
    );
  }
}
