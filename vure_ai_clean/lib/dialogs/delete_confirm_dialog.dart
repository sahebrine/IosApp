import 'package:flutter/material.dart';

class DeleteConfirmDialog extends StatelessWidget {
  final String keyVal;
  final String user;
  final Function onConfirm;

  const DeleteConfirmDialog({
    super.key,
    required this.keyVal,
    required this.user,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF101729),
      title:
          const Text("Confirm Delete", style: TextStyle(color: Colors.white)),
      content: Text(
        "Are you sure you want to delete this key?\n\nKey: $keyVal\nUser: $user",
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
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Delete"),
        ),
      ],
    );
  }
}
