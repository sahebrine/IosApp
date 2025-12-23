import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String? status;

  const StatusBadge(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status) {
      case "Active":
        color = Colors.green;
      case "Pending":
        color = Colors.orange;
      case "Expired":
        color = Colors.red;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: color.withOpacity(0.2),
      ),
      child: Text(
        status ?? "",
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
