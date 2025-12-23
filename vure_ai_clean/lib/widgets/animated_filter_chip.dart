import 'package:flutter/material.dart';

class AnimatedFilterChip extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const AnimatedFilterChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  State<AnimatedFilterChip> createState() => _AnimatedFilterChipState();
}

class _AnimatedFilterChipState extends State<AnimatedFilterChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _begin;
  late Animation<Alignment> _end;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _begin = Tween(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _end = Tween(
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.only(left: 8),
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: widget.active
                  ? LinearGradient(
                      begin: _begin.value,
                      end: _end.value,
                      colors: const [
                        Color(0xFF7C4DFF),
                        Color(0xFF5E35B1),
                        Color(0xFF4527A0),
                      ],
                    )
                  : null,
              color: widget.active
                  ? null
                  : Colors.transparent,
              border: Border.all(
                color: widget.active
                    ? Colors.transparent
                    : Colors.white24,
              ),
              boxShadow: widget.active
                  ? [
                      BoxShadow(
                        color: const Color(0xFF7C4DFF)
                            .withOpacity(.45),
                        blurRadius: 18,
                      ),
                    ]
                  : [],
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: widget.active
                    ? Colors.white
                    : Colors.white70,
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
