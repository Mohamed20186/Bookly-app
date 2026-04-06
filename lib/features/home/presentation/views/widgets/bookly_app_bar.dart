import 'package:flutter/material.dart';
import 'package:test_app/core/utils/color_palette.dart';
import 'package:test_app/features/search/presentation/bookly_search_view.dart';

class BooklyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BooklyAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(0, 248, 248, 248),
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.backgroundDark, AppColor.backgroundDeep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x55000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Glowing icon container
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColor.ceriseRed.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColor.ceriseRed.withOpacity(0.4),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.ceriseRed.withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: AppColor.ceriseRed,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          // App name with styled text
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Book',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                TextSpan(
                  text: 'ly',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColor.ceriseRed,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        // Search button
        _AppBarActionButton(
          icon: Icons.search_rounded,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BooklySearchView()),
          ),
        ),
        const SizedBox(width: 6),

        // Notification button with badge
        Stack(
          alignment: Alignment.center,
          children: [
            _AppBarActionButton(
              icon: Icons.notifications_none_rounded,
              onTap: () {
                // TODO: handle notifications
              },
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColor.ceriseRed,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF1B1035),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _AppBarActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _AppBarActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Icon(icon, color: Colors.white.withOpacity(0.85), size: 20),
      ),
    );
  }
}
