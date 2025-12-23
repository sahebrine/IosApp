import 'package:flutter/material.dart';

class ResetConfirmDialog extends StatelessWidget {
  final String keyValue;
  final VoidCallback onConfirm;

  const ResetConfirmDialog({
    super.key,
    required this.keyValue,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF131B2E),
      title: const Text("تأكيد إعادة التعيين",
          style: TextStyle(color: Colors.white)),
      content: Text(
        "هل تريد إعادة تعيين HWID للكود:\n$keyValue ؟",
        style: const TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
            child: const Text("إلغاء", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context)),
        TextButton(
          child: const Text("تأكيد", style: TextStyle(color: Colors.blue)),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
        ),
      ],
    );
  }
}
