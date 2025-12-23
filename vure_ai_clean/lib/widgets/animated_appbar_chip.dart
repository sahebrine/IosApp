import 'package:flutter/material.dart';

class AnimatedAppBarChip extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final bool outlined;
  final List<Color> colors;

  const AnimatedAppBarChip({
    super.key,
    required this.text,
    this.onTap,
    this.outlined = false,
    required this.colors,
  });

  @override
  State<AnimatedAppBarChip> createState() => _AnimatedAppBarChipState();
}

class _AnimatedAppBarChipState extends State<AnimatedAppBarChip>
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
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _a2 = Tween(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return GestureDetector(
          onTap: widget.onTap,
          child: Container(
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              gradient: widget.outlined
                  ? null
                  : LinearGradient(
                      begin: _a1.value,
                      end: _a2.value,
                      colors: widget.colors,
                    ),
              color: widget.outlined ? Colors.transparent : null,
              borderRadius: BorderRadius.circular(20),
              border:
                  widget.outlined ? Border.all(color: Colors.white24) : null,
              boxShadow: widget.outlined
                  ? null
                  : [
                      BoxShadow(
                        color: widget.colors.first.withOpacity(.45),
                        blurRadius: 16,
                      ),
                    ],
            ),
            alignment: Alignment.center,
            child: Text(
              widget.text,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
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
