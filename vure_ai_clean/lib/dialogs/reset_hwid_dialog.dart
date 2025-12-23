import 'package:flutter/material.dart';

class ResetHWIDDialog extends StatelessWidget {
  final String keyVal;
  final String user;
  final Function onConfirm;

  const ResetHWIDDialog({
    super.key,
    required this.keyVal,
    required this.user,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF101729),
      title: const Text("Reset HWID", style: TextStyle(color: Colors.white)),
      content: Text(
        "Reset HWID for key:\n\n$keyVal\nUser: $user",
        style: const TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text("Reset"),
        ),
      ],
    );
  }
}
