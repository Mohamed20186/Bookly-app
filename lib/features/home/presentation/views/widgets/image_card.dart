import 'dart:math';
import 'package:flutter/material.dart';
import 'package:test_app/core/utils/color_palette.dart';

class ImageCard extends StatefulWidget {
  const ImageCard({super.key, required this.imageUrl, this.title});

  final String imageUrl;
  final String? title;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _glowAnim;
  late Animation<double> _shimmerAnim;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _glowAnim = Tween<double>(
      begin: 0.25,
      end: 0.65,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _shimmerAnim = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _floatAnim = Tween<double>(
      begin: 0,
      end: -5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 20,
        bottom: 8,
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnim.value,
            child: Transform.translate(
              offset: Offset(0, _floatAnim.value),
              child: Container(
                width: 150,
                decoration: BoxDecoration(
                  color: AppColor.ceriseRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColor.ceriseRed.withOpacity(0.9),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.ceriseRed.withOpacity(_glowAnim.value),
                      blurRadius: 18,
                      spreadRadius: 3,
                    ),
                    BoxShadow(
                      color: AppColor.ceriseRed.withOpacity(0.15),
                      blurRadius: 6,
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Stack(
                    children: [
                      // ── Network Image ─────────────────────────────────
                      Image.network(
                        widget.imageUrl,
                        width: 150,

                        fit: BoxFit.cover,

                        // Loading placeholder
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 150,
                            height: 200,
                            color: AppColor.ceriseRed.withOpacity(0.08),
                            child: Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                                color: AppColor.ceriseRed,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },

                        // Error fallback
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 150,
                            height: 200,
                            color: AppColor.ceriseRed.withOpacity(0.08),
                            child: const Center(
                              child: Icon(
                                Icons.broken_image_rounded,
                                color: AppColor.ceriseRed,
                                size: 36,
                              ),
                            ),
                          );
                        },
                      ),

                      // ── Dark gradient overlay at the bottom (for title) ──
                      if (widget.title != null)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.75),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Text(
                              widget.title!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ),

                      // ── Shimmer sweep overlay ─────────────────────────
                      Positioned.fill(
                        child: Transform.rotate(
                          angle: pi / 4,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [
                                  (_shimmerAnim.value - 0.3).clamp(0.0, 1.0),
                                  _shimmerAnim.value.clamp(0.0, 1.0),
                                  (_shimmerAnim.value + 0.3).clamp(0.0, 1.0),
                                ],
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withOpacity(0.12),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


// ─── USAGE EXAMPLE ───────────────────────────────────────────────────────────
//
// ImageCard(
//   imageUrl: book.coverUrl,   // URL string coming from your API model
//   title: book.title,         // optional — shows a gradient title overlay
// )