import 'package:flutter/material.dart';
import 'package:test_app/core/utils/color_palette.dart'
    show AppColor, BookTheme;
import 'package:test_app/features/home/data/model/book_model.dart' show BookModel;
import 'package:test_app/features/home/presentation/views/widgets/book_detail_page.dart'
    show BookDetailPage;

// ─────────────────────────────────────────────
//  SAMPLE DATA
// ─────────────────────────────────────────────
final List<BookModel> bestSellers = [
  BookModel(
    rank: 1,
    title: 'The Great Gatsby',
    author: 'F. Scott Fitzgerald',
    rating: 4.5,
    reviewCount: 12840,
    genre: 'Classic',
    coverUrl: 'https://covers.openlibrary.org/b/id/8432472-L.jpg',
    price: '\$14.99',
    isNew: false,
  ),
  BookModel(
    rank: 2,
    title: 'Atomic Habits',
    author: 'James Clear',
    rating: 4.8,
    reviewCount: 45210,
    genre: 'Self-Help',
    coverUrl: 'https://covers.openlibrary.org/b/id/10909258-L.jpg',
    price: '\$18.99',
    isNew: true,
  ),
  BookModel(
    rank: 3,
    title: 'Dune',
    author: 'Frank Herbert',
    rating: 4.7,
    reviewCount: 33560,
    genre: 'Sci-Fi',
    coverUrl: 'https://covers.openlibrary.org/b/id/8229112-L.jpg',
    price: '\$16.99',
    isNew: false,
  ),
  BookModel(
    rank: 4,
    title: 'The Midnight Library',
    author: 'Matt Haig',
    rating: 4.3,
    reviewCount: 28900,
    genre: 'Fiction',
    coverUrl: 'https://covers.openlibrary.org/b/id/10527843-L.jpg',
    price: '\$15.49',
    isNew: true,
  ),
  BookModel(
    rank: 5,
    title: 'Sapiens',
    author: 'Yuval Noah Harari',
    rating: 4.6,
    reviewCount: 50120,
    genre: 'History',
    coverUrl: 'https://covers.openlibrary.org/b/id/8228692-L.jpg',
    price: '\$17.99',
    isNew: false,
  ),
  BookModel(
    rank: 6,
    title: '1984',
    author: 'George Orwell',
    rating: 4.9,
    reviewCount: 61330,
    genre: 'Dystopia',
    coverUrl: 'https://covers.openlibrary.org/b/id/8575708-L.jpg',
    price: '\$12.99',
    isNew: false,
  ),
];

// ─────────────────────────────────────────────
//  BEST SELLER BOOK CARD  ⭐
// ─────────────────────────────────────────────
class BestSellerBookCard extends StatefulWidget {
  final BookModel book;
  final Duration animationDelay;

  const BestSellerBookCard({
    super.key,
    required this.book,
    this.animationDelay = Duration.zero,
  });

  @override
  State<BestSellerBookCard> createState() => _BestSellerBookCardState();
}

class _BestSellerBookCardState extends State<BestSellerBookCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(widget.animationDelay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Navigate to detail page ──
  void _openDetail(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BookDetailPage(book: widget.book),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.06),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: GestureDetector(
          onTap: () => _openDetail(context), // ← navigate on tap
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _pressed ? 0.97 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: _buildCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      decoration: BoxDecoration(
        color: BookTheme.cardBg.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BookTheme.accent, width: 1),
        boxShadow: [BoxShadow(color: AppColor.surface, blurRadius: 20)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Cover + Rank Badge ──
          Stack(
            children: [
              _buildCover(),
              Positioned(
                top: 8,
                left: 8,
                child: _RankBadge(rank: widget.book.rank),
              ),
              if (widget.book.isNew)
                Positioned(bottom: 8, left: 8, child: _NewBadge()),
            ],
          ),

          // ── Info ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Genre chip
                  _GenreChip(genre: widget.book.genre),
                  const SizedBox(height: 8),

                  // Title
                  Text(
                    widget.book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: BookTheme.fontDisplay,
                      color: BookTheme.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Author
                  Text(
                    widget.book.author,
                    style: const TextStyle(
                      color: BookTheme.textSecondary,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Rating row
                  _RatingRow(
                    rating: widget.book.rating,
                    reviewCount: widget.book.reviewCount,
                  ),
                  const SizedBox(height: 14),

                  // Price + CTA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Price',
                            style: TextStyle(
                              color: BookTheme.textSecondary,
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            widget.book.price,
                            style: const TextStyle(
                              color: AppColor.ceriseRed,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      _AddToCartButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCover() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        bottomLeft: Radius.circular(16),
      ),
      child: Image.network(
        widget.book.coverUrl,
        width: 110,
        height: 170,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: 110,
            height: 170,
            color: BookTheme.surface,
            child: Center(
              child: CircularProgressIndicator(
                value: progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                    : null,
                color: AppColor.ceriseRed,
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 110,
            height: 170,
            color: BookTheme.surface,
            child: const Center(
              child: Icon(
                Icons.menu_book_rounded,
                color: AppColor.ceriseRed,
                size: 36,
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SUB-WIDGETS
// ─────────────────────────────────────────────

class _RankBadge extends StatelessWidget {
  final int rank;
  const _RankBadge({required this.rank});

  Color get _color {
    if (rank == 1) return const Color(0xFFFFD700);
    if (rank == 2) return const Color(0xFFC0C0C0);
    if (rank == 3) return const Color(0xFFCD7F32);
    return BookTheme.surface;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: _color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _color.withOpacity(0.5),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '#$rank',
          style: const TextStyle(
            color: Color(0xFF0F0E17),
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.3,
          ),
        ),
      ),
    );
  }
}

class _NewBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: BookTheme.accent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        'NEW',
        style: TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  final String genre;
  const _GenreChip({required this.genre});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.ceriseRed.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.ceriseRed.withOpacity(0.3)),
      ),
      child: Text(
        genre.toUpperCase(),
        style: const TextStyle(
          color: AppColor.ceriseRed,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const _RatingRow({required this.rating, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: List.generate(5, (i) {
            final full = i < rating.floor();
            final half = !full && i < rating;
            return Icon(
              full
                  ? Icons.star_rounded
                  : half
                  ? Icons.star_half_rounded
                  : Icons.star_outline_rounded,
              color: AppColor.ceriseRed,
              size: 15,
            );
          }),
        ),
        const SizedBox(width: 6),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            color: BookTheme.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '(${_formatCount(reviewCount)})',
          style: const TextStyle(color: BookTheme.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  String _formatCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }
}

class _AddToCartButton extends StatefulWidget {
  @override
  State<_AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<_AddToCartButton> {
  bool _added = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _added = !_added);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: _added ? AppColor.ceriseRed : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _added ? AppColor.ceriseRed : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _added ? Icons.check_rounded : Icons.shopping_bag_outlined,
              color: _added ? BookTheme.background : BookTheme.textSecondary,
              size: 15,
            ),
            const SizedBox(width: 5),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: _added ? BookTheme.background : BookTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              child: Text(_added ? 'Added' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }
}
