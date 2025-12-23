import 'package:flutter/material.dart';

class DeleteConfirmDialog extends StatelessWidget {
  final String keyValue;
  final VoidCallback onConfirm;

  const DeleteConfirmDialog({
    super.key,
    required this.keyValue,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF131B2E),
      title: const Text("تأكيد الحذف", style: TextStyle(color: Colors.white)),
      content: Text(
        "هل أنت متأكد من حذف الكود:\n$keyValue ؟",
        style: const TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
            child: const Text("إلغاء", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context)),
        TextButton(
          child: const Text("حذف", style: TextStyle(color: Colors.red)),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
        ),
      ],
    );
  }
}
