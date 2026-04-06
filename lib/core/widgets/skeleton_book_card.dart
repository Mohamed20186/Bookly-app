// skeleton_book_card.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:test_app/core/utils/color_palette.dart' show BookTheme;

class SkeletonBookCard extends StatelessWidget {
  const SkeletonBookCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: BookTheme.surface,
      highlightColor: BookTheme.cardBg.withOpacity(0.4),
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          color: BookTheme.cardBg.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BookTheme.accent, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover placeholder
            Container(
              width: 110,
              height: 170,
              decoration: BoxDecoration(
                color: BookTheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),

            // Info placeholders
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Genre chip
                    _Box(width: 60, height: 20, radius: 20),
                    const SizedBox(height: 10),
                    // Title line 1
                    _Box(width: double.infinity, height: 14, radius: 6),
                    const SizedBox(height: 6),
                    // Title line 2
                    _Box(width: 140, height: 14, radius: 6),
                    const SizedBox(height: 8),
                    // Author
                    _Box(width: 100, height: 12, radius: 6),
                    const SizedBox(height: 14),
                    // Stars
                    _Box(width: 120, height: 12, radius: 6),
                    const Spacer(),
                    // Price + button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _Box(width: 50, height: 18, radius: 6),
                        _Box(width: 70, height: 34, radius: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final double width, height, radius;
  const _Box({required this.width, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: BookTheme.surface,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}