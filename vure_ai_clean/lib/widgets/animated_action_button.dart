import 'package:flutter/material.dart';

enum ActionType { reset, extend, delete }

class AnimatedActionButton extends StatefulWidget {
  final String text;
  final ActionType type;
  final VoidCallback onTap;

  const AnimatedActionButton({
    super.key,
    required this.text,
    required this.type,
    required this.onTap,
  });

  @override
  State<AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<AnimatedActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _a1;
  late Animation<Alignment> _a2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _a1 = Tween(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _a2 = Tween(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  List<Color> get colors {
    switch (widget.type) {
      case ActionType.reset:
        return const [
          Color(0xFF2563EB),
          Color(0xFF38BDF8),
          Color(0xFF1E40AF),
        ];
      case ActionType.extend:
        return const [
          Color(0xFF16A34A),
          Color(0xFF4ADE80),
          Color(0xFF166534),
        ];
      case ActionType.delete:
        return const [
          Color(0xFFDC2626),
          Color(0xFFF87171),
          Color(0xFF7F1D1D),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: _a1.value,
                end: _a2.value,
                colors: colors,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              widget.text,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
