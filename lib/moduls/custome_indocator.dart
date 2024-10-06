

import 'package:flutter/material.dart';

class GradiantProgressIndicator extends StatefulWidget {
  final int targetPercent;
  final LinearGradient gradient;
  final Color backgroundColor;

  const GradiantProgressIndicator({
    required this.targetPercent,
    required this.gradient,
    required this.backgroundColor,
    Key? key,
  }) : super(key: key);

  @override
  _GradiantProgressIndicatorState createState() => _GradiantProgressIndicatorState();
}

class _GradiantProgressIndicatorState extends State<GradiantProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _setupAnimation();
  }

  void _setupAnimation() {
    _animation = Tween<double>(begin: _currentProgress, end: widget.targetPercent / 100)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward(from: 0.0); // Start the animation
  }

  @override
  void didUpdateWidget(GradiantProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetPercent != widget.targetPercent) {
      _currentProgress = _animation.value;
      _controller.reset();
      _animation = Tween<double>(begin: _currentProgress, end: widget.targetPercent / 100)
          .animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final flexValue = (_animation.value * 100).toInt();
        return Row(
          children: [
            Flexible(
              flex: flexValue,
              fit: FlexFit.tight,
              child: Container(
                decoration: BoxDecoration(
                  gradient: widget.gradient,
                  borderRadius: flexValue == 100
                      ? const BorderRadius.all(Radius.circular(4))
                      : const BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    topLeft: Radius.circular(4),
                  ),
                ),
                child: const SizedBox(height: 10.0),
              ),
            ),
            Flexible(
              flex: 100 - flexValue,
              fit: FlexFit.tight,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: flexValue == 0
                      ? const BorderRadius.all(Radius.circular(4))
                      : const BorderRadius.only(
                    bottomRight: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
                child: const SizedBox(height: 10.0),
              ),
            ),
          ],
        );
      },
    );
  }
}