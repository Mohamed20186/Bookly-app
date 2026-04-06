import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/core/utils/color_palette.dart' show AppColor, BookTheme;
import 'package:test_app/features/home/data/model/book_model.dart' show BookModel;

// ─────────────────────────────────────────────
//  BOOK DETAIL PAGE
// ─────────────────────────────────────────────
class BookDetailPage extends StatefulWidget {
  final BookModel book;

  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _contentController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;
  late Animation<double> _scaleIn;

  bool _isWishlisted = false;
  bool _isAddedToCart = false;
  int _selectedTabIndex = 0;

  final List<String> _tabs = ['Overview', 'Details', 'Reviews'];

  // Mock description paragraphs
  static const String _description =
      'A sweeping tale that has captivated generations of readers, this masterwork '
      'draws you into a world where every page drips with atmosphere, meaning, and '
      'unforgettable characters. The prose cuts like light through stained glass — '
      'precise, luminous, and utterly transporting.\n\n'
      'Widely regarded as one of the defining works of its era, it continues to '
      'spark debate, inspire writers, and resonate with readers across cultures. '
      'Whether you\'re returning for the tenth time or discovering it fresh, '
      'there is always something new to uncover.';

  static const List<Map<String, String>> _details = [
    {'label': 'Publisher', 'value': 'Penguin Classics'},
    {'label': 'Language', 'value': 'English'},
    {'label': 'Pages', 'value': '320'},
    {'label': 'ISBN-13', 'value': '978-0-14-303943-3'},
    {'label': 'Dimensions', 'value': '7.7 × 5.1 × 0.7 in'},
    {'label': 'Format', 'value': 'Paperback'},
  ];

  static const List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Elena R.',
      'avatar': 'E',
      'rating': 5.0,
      'date': 'Mar 2025',
      'text':
          'One of the most profound reading experiences of my life. Every sentence feels deliberate.',
    },
    {
      'name': 'Marcus T.',
      'avatar': 'M',
      'rating': 4.5,
      'date': 'Feb 2025',
      'text':
          'Beautifully written. The pacing takes some getting used to, but the payoff is immense.',
    },
    {
      'name': 'Sophia K.',
      'avatar': 'S',
      'rating': 5.0,
      'date': 'Jan 2025',
      'text':
          'Re-read this for the third time and it still hits differently. A true classic.',
    },
  ];

  @override
  void initState() {
    super.initState();

    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeIn = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOut,
    );
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOutCubic,
    ));
    _scaleIn = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOutBack),
    );

    _heroController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _contentController.forward();
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: BookTheme.background,
        body: Stack(
          children: [
            // ── Blurred ambient background ──
            _AmbientBackground(coverUrl: widget.book.coverUrl),

            // ── Main scrollable content ──
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildAppBar(context),
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeIn,
                    child: SlideTransition(
                      position: _slideUp,
                      child: Column(
                        children: [
                          _buildHeroSection(),
                          _buildMetaRow(),
                          _buildTabBar(),
                          _buildTabContent(),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Floating bottom bar ──
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _BottomBar(
                price: widget.book.price,
                isAddedToCart: _isAddedToCart,
                onCartTap: () {
                  setState(() => _isAddedToCart = !_isAddedToCart);
                  HapticFeedback.mediumImpact();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── App Bar ───────────────────────────────
  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: false,
      floating: true,
      leadingWidth: 56,
      leading: _CircleIconButton(
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: () => Navigator.of(context).pop(),
      ),
      actions: [
        _CircleIconButton(
          icon: _isWishlisted
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          iconColor:
              _isWishlisted ? AppColor.ceriseRed : BookTheme.textSecondary,
          onTap: () {
            setState(() => _isWishlisted = !_isWishlisted);
            HapticFeedback.lightImpact();
          },
        ),
        const SizedBox(width: 8),
        _CircleIconButton(
          icon: Icons.ios_share_rounded,
          onTap: () {},
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  // ─── Hero Section ──────────────────────────
  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 8),

          // Cover with glow
          ScaleTransition(
            scale: _scaleIn,
            child: _CoverWithGlow(book: widget.book),
          ),

          const SizedBox(height: 28),

          // Genre chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: AppColor.ceriseRed.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColor.ceriseRed.withOpacity(0.35)),
            ),
            child: Text(
              widget.book.genre.toUpperCase(),
              style: const TextStyle(
                color: AppColor.ceriseRed,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Title
          Text(
            widget.book.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: BookTheme.fontDisplay,
              color: BookTheme.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 8),

          // Author
          Text(
            'by ${widget.book.author}',
            style: const TextStyle(
              color: BookTheme.textSecondary,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 18),

          // Rating row
          _LargeRatingRow(
            rating: widget.book.rating,
            reviewCount: widget.book.reviewCount,
          ),
        ],
      ),
    );
  }

  // ─── Meta Row ──────────────────────────────
  Widget _buildMetaRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Row(
        children: [
          _MetaTile(
            icon: Icons.bar_chart_rounded,
            label: 'Rank',
            value: '#${widget.book.rank}',
          ),
          _MetaDivider(),
          _MetaTile(
            icon: Icons.auto_stories_rounded,
            label: 'Pages',
            value: '320',
          ),
          _MetaDivider(),
          _MetaTile(
            icon: Icons.language_rounded,
            label: 'Language',
            value: 'EN',
          ),
          _MetaDivider(),
          _MetaTile(
            icon: Icons.inventory_2_outlined,
            label: 'Format',
            value: 'Paper',
          ),
        ],
      ),
    );
  }

  // ─── Tab Bar ───────────────────────────────
  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final selected = i == _selectedTabIndex;
          return GestureDetector(
            onTap: () => setState(() => _selectedTabIndex = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: selected
                    ? AppColor.ceriseRed
                    : BookTheme.cardBg.withOpacity(0.15),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: selected
                      ? AppColor.ceriseRed
                      : BookTheme.accent.withOpacity(0.3),
                ),
              ),
              child: Text(
                _tabs[i],
                style: TextStyle(
                  color:
                      selected ? Colors.white : BookTheme.textSecondary,
                  fontSize: 13,
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─── Tab Content ───────────────────────────
  Widget _buildTabContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(anim),
          child: child,
        ),
      ),
      child: KeyedSubtree(
        key: ValueKey(_selectedTabIndex),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
          child: _selectedTabIndex == 0
              ? _OverviewTab(description: _description)
              : _selectedTabIndex == 1
                  ? _DetailsTab(details: _details)
                  : _ReviewsTab(reviews: _reviews),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  AMBIENT BACKGROUND
// ─────────────────────────────────────────────
class _AmbientBackground extends StatelessWidget {
  final String coverUrl;
  const _AmbientBackground({required this.coverUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Solid base
        Container(color: BookTheme.background),
        // Soft glow at top
        Positioned(
          top: -60,
          left: 0,
          right: 0,
          child: Container(
            height: 350,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.2,
                colors: [
                  AppColor.ceriseRed.withOpacity(0.18),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  COVER WITH GLOW
// ─────────────────────────────────────────────
class _CoverWithGlow extends StatelessWidget {
  final BookModel book;
  const _CoverWithGlow({required this.book});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow
        Container(
          width: 160,
          height: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColor.ceriseRed.withOpacity(0.35),
                blurRadius: 50,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
        // Cover image
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            book.coverUrl,
            width: 160,
            height: 220,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                width: 160,
                height: 220,
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
            errorBuilder: (_, _, _) => Container(
              width: 160,
              height: 220,
              color: BookTheme.surface,
              child: const Icon(
                Icons.menu_book_rounded,
                color: AppColor.ceriseRed,
                size: 48,
              ),
            ),
          ),
        ),
        // Rank badge
        Positioned(
          top: 10,
          right: 10,
          child: _RankBadge(rank: book.rank),
        ),
        if (book.isNew)
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  LARGE RATING ROW
// ─────────────────────────────────────────────
class _LargeRatingRow extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const _LargeRatingRow({required this.rating, required this.reviewCount});

  String _formatCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
              size: 18,
            );
          }),
        ),
        const SizedBox(width: 8),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            color: BookTheme.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          '(${_formatCount(reviewCount)} reviews)',
          style: const TextStyle(
            color: BookTheme.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  META TILE
// ─────────────────────────────────────────────
class _MetaTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetaTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: BookTheme.cardBg.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: BookTheme.accent.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColor.ceriseRed, size: 18),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: BookTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: BookTheme.textSecondary,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const SizedBox(width: 8);
}

// ─────────────────────────────────────────────
//  OVERVIEW TAB
// ─────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  final String description;
  const _OverviewTab({required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About this book',
          style: TextStyle(
            fontFamily: BookTheme.fontDisplay,
            color: BookTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: const TextStyle(
            color: BookTheme.textSecondary,
            fontSize: 14,
            height: 1.75,
          ),
        ),
        const SizedBox(height: 24),
        // Tags
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['Literary Fiction', 'Award Winner', 'Bestseller', 'Classic']
              .map((tag) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: BookTheme.surface.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: BookTheme.accent.withOpacity(0.3)),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: BookTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  DETAILS TAB
// ─────────────────────────────────────────────
class _DetailsTab extends StatelessWidget {
  final List<Map<String, String>> details;
  const _DetailsTab({required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Book Information',
          style: TextStyle(
            fontFamily: BookTheme.fontDisplay,
            color: BookTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: BookTheme.cardBg.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: BookTheme.accent.withOpacity(0.25)),
          ),
          child: Column(
            children: details.asMap().entries.map((entry) {
              final isLast = entry.key == details.length - 1;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.value['label']!,
                          style: const TextStyle(
                            color: BookTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          entry.value['value']!,
                          style: const TextStyle(
                            color: BookTheme.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      color: BookTheme.accent.withOpacity(0.2),
                      indent: 18,
                      endIndent: 18,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  REVIEWS TAB
// ─────────────────────────────────────────────
class _ReviewsTab extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  const _ReviewsTab({required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reader Reviews',
          style: TextStyle(
            fontFamily: BookTheme.fontDisplay,
            color: BookTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...reviews.map((review) => _ReviewCard(review: review)),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final double rating = review['rating'] as double;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BookTheme.cardBg.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BookTheme.accent.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColor.ceriseRed.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColor.ceriseRed.withOpacity(0.4)),
                ),
                child: Center(
                  child: Text(
                    review['avatar'] as String,
                    style: const TextStyle(
                      color: AppColor.ceriseRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'] as String,
                      style: const TextStyle(
                        color: BookTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      review['date'] as String,
                      style: const TextStyle(
                        color: BookTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < rating.floor()
                        ? Icons.star_rounded
                        : i < rating
                            ? Icons.star_half_rounded
                            : Icons.star_outline_rounded,
                    color: AppColor.ceriseRed,
                    size: 13,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['text'] as String,
            style: const TextStyle(
              color: BookTheme.textSecondary,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  BOTTOM BAR
// ─────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  final String price;
  final bool isAddedToCart;
  final VoidCallback onCartTap;

  const _BottomBar({
    required this.price,
    required this.isAddedToCart,
    required this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: BookTheme.background.withOpacity(0.95),
        border: Border(
          top: BorderSide(color: BookTheme.accent.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          // Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Price',
                style: TextStyle(
                  color: BookTheme.textSecondary,
                  fontSize: 11,
                  letterSpacing: 1,
                ),
              ),
              Text(
                price,
                style: const TextStyle(
                  color: AppColor.ceriseRed,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          // Add to cart
          Expanded(
            child: GestureDetector(
              onTap: onCartTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 52,
                decoration: BoxDecoration(
                  color: isAddedToCart
                      ? Colors.transparent
                      : AppColor.ceriseRed,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isAddedToCart
                        ? BookTheme.accent
                        : AppColor.ceriseRed,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isAddedToCart
                          ? Icons.check_circle_outline_rounded
                          : Icons.shopping_bag_outlined,
                      color: isAddedToCart
                          ? BookTheme.textSecondary
                          : Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        color: isAddedToCart
                            ? BookTheme.textSecondary
                            : Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      child: Text(isAddedToCart ? 'Added to Cart' : 'Add to Cart'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  REUSABLE WIDGETS (copied from card file)
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
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: _color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _color.withOpacity(0.5),
            blurRadius: 10,
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

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: BookTheme.cardBg.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(color: BookTheme.accent.withOpacity(0.3)),
        ),
        child: Icon(
          icon,
          color: iconColor ?? BookTheme.textSecondary,
          size: 18,
        ),
      ),
    );
  }
}