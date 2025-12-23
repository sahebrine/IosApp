import 'package:flutter/material.dart';

class ExtendDaysDialog extends StatefulWidget {
  final String keyValue;
  final bool isGlobal;
  final Function(String days) onConfirm;

  const ExtendDaysDialog({
    super.key,
    required this.keyValue,
    required this.onConfirm,
    this.isGlobal = false,
  });

  @override
  State<ExtendDaysDialog> createState() => _ExtendDaysDialogState();
}

class _ExtendDaysDialogState extends State<ExtendDaysDialog> {
  final TextEditingController days = TextEditingController(text: "1");

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF131B2E),
      title: Text(
        widget.isGlobal ? "إضافة أيام للجميع" : "إضافة أيام",
        style: const TextStyle(color: Colors.white),
      ),
      content: TextField(
        controller: days,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          label: Text("عدد الأيام", style: TextStyle(color: Colors.white70)),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("إلغاء", style: TextStyle(color: Colors.white)),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text("تأكيد", style: TextStyle(color: Colors.green)),
          onPressed: () {
            Navigator.pop(context);
            widget.onConfirm(days.text);
          },
        ),
      ],
    );
  }
}
