import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/utils/color_palette.dart';

class FloatingParticle extends StatelessWidget {
  final AnimationController controller;
  final int index;
  final Size screenSize;

  const FloatingParticle({super.key, 
    required this.controller,
    required this.index,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    final random = math.Random(index * 42);
    final startX = random.nextDouble() * screenSize.width;
    final startY = random.nextDouble() * screenSize.height;
    final size = 8.0 + random.nextDouble() * 16;
    final speed = 0.3 + random.nextDouble() * 0.7;
    final delay = random.nextDouble();

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final t = ((controller.value + delay) % 1.0);
        final opacity = math.sin(t * math.pi).clamp(0.0, 1.0);
        final yOffset = -60 * t * speed;
        final xOffset = math.sin(t * math.pi * 2) * 15;

        return Positioned(
          left: startX + xOffset,
          top: startY + yOffset,
          child: Opacity(
            opacity: opacity * 0.4,
            child: Icon(
              index % 2 == 0 ? Icons.menu_book_rounded : Icons.bookmark_rounded,
              color: index % 3 == 0 ? AppColor.ceriseRed : AppColor.royalPurple,
              size: size,
            ),
          ),
        );
      },
    );
  }
}
