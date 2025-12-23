import 'package:flutter/material.dart';

class CreateKeyDialog extends StatefulWidget {
  final Function(String duration, String name) onConfirm;

  const CreateKeyDialog({required this.onConfirm, super.key});

  @override
  State<CreateKeyDialog> createState() => _CreateKeyDialogState();
}

class _CreateKeyDialogState extends State<CreateKeyDialog> {
  final TextEditingController duration = TextEditingController(text: "30 days");
  final TextEditingController name = TextEditingController(text: "-");

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF131B2E),
      title: const Text("إنشاء كود", style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          TextField(
            controller: name,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "الاسم",
              labelStyle: TextStyle(color: Colors.white70),
            ),
          ),
          TextField(
            controller: duration,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "المدة (أيام)",
              labelStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("إلغاء", style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.purple,
          ),
          onPressed: () {
            widget.onConfirm(
              duration.text,
              name.text.isEmpty ? "-" : name.text,
            );
            Navigator.pop(context);
          },
          child: const Text("إنشاء"),
        ),
      ],
    );
  }
}
