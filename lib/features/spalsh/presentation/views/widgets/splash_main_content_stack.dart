import 'package:flutter/material.dart';
import 'package:test_app/core/utils/color_palette.dart';
import 'package:test_app/features/spalsh/presentation/views/widgets/animated_loading_bar.dart';

class SplashMainContentStack extends StatelessWidget {
  const SplashMainContentStack({
    super.key,
    required AnimationController logoController,
    required Animation<double> logoOpacity,
    required Animation<double> logoScale,
    required AnimationController textController,
    required Animation<double> textOpacity,
    required Animation<Offset> textSlide,
    required AnimationController shimmerController,
    required Animation<double> shimmer,
  }) : _logoController = logoController,
       _logoOpacity = logoOpacity,
       _logoScale = logoScale,
       _textController = textController,
       _textOpacity = textOpacity,
       _textSlide = textSlide,
       _shimmerController = shimmerController,
       _shimmer = shimmer;

  final AnimationController _logoController;
  final Animation<double> _logoOpacity;
  final Animation<double> _logoScale;
  final AnimationController _textController;
  final Animation<double> _textOpacity;
  final Animation<Offset> _textSlide;
  final AnimationController _shimmerController;
  final Animation<double> _shimmer;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Centered logo + text
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoOpacity.value,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer glow
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.ceriseRed.withOpacity(0.3),
                                blurRadius: 60,
                                spreadRadius: 20,
                              ),
                              BoxShadow(
                                color: AppColor.royalPurple.withOpacity(0.2),
                                blurRadius: 80,
                                spreadRadius: 30,
                              ),
                            ],
                          ),
                        ),
                        // Scaled logo
                        Transform.scale(
                          scale: _logoScale.value,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Ring border
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColor.ceriseRed.withOpacity(0.4),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              // Icon circle
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppColor.brandGradient,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColor.ceriseRed.withOpacity(
                                        0.4,
                                      ),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.auto_stories_rounded,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // App name with shimmer
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _textOpacity,
                    child: SlideTransition(position: _textSlide, child: child),
                  );
                },
                child: AnimatedBuilder(
                  animation: _shimmerController,
                  builder: (context, child) {
                    return ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          colors: const [
                            Colors.white,
                            AppColor.ceriseRed,
                            Colors.white,
                          ],
                          stops: [
                            (_shimmer.value - 0.3).clamp(0.0, 1.0),
                            _shimmer.value.clamp(0.0, 1.0),
                            (_shimmer.value + 0.3).clamp(0.0, 1.0),
                          ],
                        ).createShader(bounds);
                      },
                      child: const Text(
                        'Bookly',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 4,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Tagline
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) =>
                    FadeTransition(opacity: _textOpacity, child: child),
                child: const Text(
                  'Your world of stories',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColor.silverMist,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Loading bar pinned to bottom
        Positioned(
          bottom: 60,
          left: 0,
          right: 0,
          child: AnimatedBuilder(
            animation: _textController,
            builder: (context, child) =>
                FadeTransition(opacity: _textOpacity, child: child),
            child: const Column(
              children: [
                AnimatedLoadingBar(),
                SizedBox(height: 12),
                Text(
                  'Loading your library...',
                  style: TextStyle(
                    color: AppColor.slateGray,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
