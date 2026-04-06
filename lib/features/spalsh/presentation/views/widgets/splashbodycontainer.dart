import 'package:flutter/material.dart';
import 'package:test_app/core/utils/color_palette.dart';
import 'package:test_app/features/spalsh/presentation/views/widgets/floating_particle_widget.dart';

import 'splash_main_content_stack.dart';

class SplashBodyContainer extends StatelessWidget {
  const SplashBodyContainer({
    super.key,
    required AnimationController particleController,
    required this.size,
    required AnimationController logoController,
    required Animation<double> logoOpacity,
    required Animation<double> logoScale,
    required AnimationController textController,
    required Animation<double> textOpacity,
    required Animation<Offset> textSlide,
    required AnimationController shimmerController,
    required Animation<double> shimmer,
  }) : _particleController = particleController, _logoController = logoController, _logoOpacity = logoOpacity, _logoScale = logoScale, _textController = textController, _textOpacity = textOpacity, _textSlide = textSlide, _shimmerController = shimmerController, _shimmer = shimmer;

  final AnimationController _particleController;
  final Size size;
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
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(gradient: AppColor.backgroundGradient),
      child: Stack(
        children: [
          // Floating book particles
          ...List.generate(8, (index) {
            return FloatingParticle(
              controller: _particleController,
              index: index,
              screenSize: size,
            );
          }),
    
          // Glowing orb behind logo
          Center(
            child: AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Opacity(
                  opacity: _logoOpacity.value,
                  child: Container(
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
                );
              },
            ),
          ),
    
          SplashMainContentStack(
            logoController: _logoController,
            logoOpacity: _logoOpacity,
            logoScale: _logoScale,
            textController: _textController,
            textOpacity: _textOpacity,
            textSlide: _textSlide,
            shimmerController: _shimmerController,
            shimmer: _shimmer,
          ),
        ],
      ),
    );
  }
}