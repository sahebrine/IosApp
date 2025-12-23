import 'package:flutter/material.dart';

class ExtendAllDialog extends StatefulWidget {
  final Function(int days) onConfirm;

  const ExtendAllDialog({super.key, required this.onConfirm});

  @override
  State<ExtendAllDialog> createState() => _ExtendAllDialogState();
}

class _ExtendAllDialogState extends State<ExtendAllDialog> {
  final TextEditingController ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF101729),
      title: const Text("Extend Days For All",
          style: TextStyle(color: Colors.white)),
      content: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: "Enter days to add",
          hintStyle: TextStyle(color: Colors.white54),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel", style: TextStyle(color: Colors.white)),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text("Apply"),
          onPressed: () {
            final days = int.tryParse(ctrl.text.trim()) ?? 0;
            widget.onConfirm(days);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
