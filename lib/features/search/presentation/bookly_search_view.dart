import 'package:flutter/material.dart';
import 'package:test_app/core/utils/color_palette.dart';

// ─────────────────────────────────────────────
// DATA MODELS (replace with your real models)
// ─────────────────────────────────────────────

class BookResult {
  final String title;
  final String author;
  final String genre;
  final double rating;
  final String coverEmoji; // placeholder until real assets

  const BookResult({
    required this.title,
    required this.author,
    required this.genre,
    required this.rating,
    required this.coverEmoji,
  });
}

// ─────────────────────────────────────────────
// SEARCH VIEW
// ─────────────────────────────────────────────

class BooklySearchView extends StatefulWidget {
  const BooklySearchView({super.key});

  @override
  State<BooklySearchView> createState() => _BooklySearchViewState();
}

class _BooklySearchViewState extends State<BooklySearchView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String _query = '';
  String _selectedCategory = 'All';
  bool _isSearching = false;

  // ── Sample data ──────────────────────────────
  final List<String> _categories = [
    'All',
    'Fiction',
    'Mystery',
    'Sci-Fi',
    'Romance',
    'History',
    'Self-Help',
  ];

  final List<String> _recentSearches = [
    'Dune',
    'The Great Gatsby',
    'Atomic Habits',
    'Project Hail Mary',
  ];

  final List<BookResult> _allBooks = const [
    BookResult(title: 'Dune', author: 'Frank Herbert', genre: 'Sci-Fi', rating: 4.8, coverEmoji: '🏜️'),
    BookResult(title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', genre: 'Fiction', rating: 4.5, coverEmoji: '🍸'),
    BookResult(title: 'Atomic Habits', author: 'James Clear', genre: 'Self-Help', rating: 4.9, coverEmoji: '⚛️'),
    BookResult(title: 'Project Hail Mary', author: 'Andy Weir', genre: 'Sci-Fi', rating: 4.9, coverEmoji: '🚀'),
    BookResult(title: 'Gone Girl', author: 'Gillian Flynn', genre: 'Mystery', rating: 4.3, coverEmoji: '🔪'),
    BookResult(title: 'Sapiens', author: 'Yuval Noah Harari', genre: 'History', rating: 4.7, coverEmoji: '🦴'),
    BookResult(title: 'The Notebook', author: 'Nicholas Sparks', genre: 'Romance', rating: 4.2, coverEmoji: '💌'),
    BookResult(title: 'Fahrenheit 451', author: 'Ray Bradbury', genre: 'Sci-Fi', rating: 4.6, coverEmoji: '🔥'),
  ];

  List<BookResult> get _filteredBooks {
    return _allBooks.where((book) {
      final matchesQuery = _query.isEmpty ||
          book.title.toLowerCase().contains(_query.toLowerCase()) ||
          book.author.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'All' || book.genre == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();

    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text;
        _isSearching = _query.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    _focusNode.requestFocus();
  }

  void _applyRecentSearch(String term) {
    _searchController.text = term;
    _searchController.selection =
        TextSelection.collapsed(offset: term.length);
    _focusNode.requestFocus();
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.backgroundDark, AppColor.backgroundDeep],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildSearchBar(),
                _buildCategoryChips(),
                const SizedBox(height: 4),
                Expanded(
                  child: _isSearching
                      ? _buildSearchResults()
                      : _buildDiscoverSection(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white.withOpacity(0.85),
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Discover ',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.4,
                  ),
                ),
                TextSpan(
                  text: 'Books',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColor.ceriseRed,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Search Bar ────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColor.ceriseRed.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          autofocus: true,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          cursorColor: AppColor.ceriseRed,
          decoration: InputDecoration(
            hintText: 'Title, author, genre…',
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.35),
              fontSize: 15,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 10),
              child: Icon(
                Icons.search_rounded,
                color: AppColor.ceriseRed.withOpacity(0.8),
                size: 22,
              ),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: _isSearching
                ? GestureDetector(
                    onTap: _clearSearch,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white.withOpacity(0.6),
                          size: 16,
                        ),
                      ),
                    ),
                  )
                : null,
            suffixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            filled: true,
            fillColor: Colors.white.withOpacity(0.07),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColor.ceriseRed,
                width: 1.4,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Category Chips ────────────────────────────

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor.ceriseRed
                    : Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColor.ceriseRed
                      : Colors.white.withOpacity(0.12),
                  width: 1.2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColor.ceriseRed.withOpacity(0.35),
                          blurRadius: 10,
                          spreadRadius: 0,
                        )
                      ]
                    : [],
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.55),
                  fontSize: 13,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Discover Section (no query) ───────────────

  Widget _buildDiscoverSection() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      children: [
        // Recent searches
        if (_recentSearches.isNotEmpty) ...[
          _SectionHeader(
            title: 'Recent Searches',
            action: 'Clear',
            onAction: () => setState(() => _recentSearches.clear()),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentSearches
                .map((term) => _RecentChip(
                      label: term,
                      onTap: () => _applyRecentSearch(term),
                    ))
                .toList(),
          ),
          const SizedBox(height: 28),
        ],

        // Trending section
        _SectionHeader(title: 'Trending Now', action: 'See all', onAction: () {}),
        const SizedBox(height: 14),
        ...List.generate(
          _allBooks.length > 4 ? 4 : _allBooks.length,
          (i) => _BookListTile(book: _allBooks[i], rank: i + 1),
        ),
      ],
    );
  }

  // ── Search Results ────────────────────────────

  Widget _buildSearchResults() {
    final results = _filteredBooks;

    if (results.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Text(
            '${results.length} result${results.length == 1 ? '' : 's'} for "$_query"',
            style: TextStyle(
              color: Colors.white.withOpacity(0.45),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            itemCount: results.length,
            itemBuilder: (context, index) =>
                _BookListTile(book: results[index]),
          ),
        ),
      ],
    );
  }

  // ── Empty State ───────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColor.ceriseRed.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColor.ceriseRed.withOpacity(0.25),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.search_off_rounded,
              color: AppColor.ceriseRed.withOpacity(0.6),
              size: 36,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'No results found',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different title, author,\nor browse by category.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.4),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SUB-WIDGETS
// ─────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onAction;

  const _SectionHeader({
    required this.title,
    required this.action,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Georgia',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        GestureDetector(
          onTap: onAction,
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColor.ceriseRed,
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _RecentChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.12),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history_rounded,
              size: 14,
              color: Colors.white.withOpacity(0.4),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.65),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookListTile extends StatelessWidget {
  final BookResult book;
  final int? rank;

  const _BookListTile({required this.book, this.rank});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Cover placeholder
            Container(
              width: 54,
              height: 76,
              decoration: BoxDecoration(
                color: AppColor.ceriseRed.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColor.ceriseRed.withOpacity(0.25),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(book.coverEmoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Genre badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColor.ceriseRed.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColor.ceriseRed.withOpacity(0.25),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          book.genre,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColor.ceriseRed,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Rating
                      const Icon(Icons.star_rounded,
                          size: 14, color: Color(0xFFFFCC00)),
                      const SizedBox(width: 3),
                      Text(
                        book.rating.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Rank badge or chevron
            const SizedBox(width: 8),
            if (rank != null)
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: rank! <= 3
                      ? AppColor.ceriseRed.withOpacity(0.2)
                      : Colors.white.withOpacity(0.06),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: rank! <= 3
                        ? AppColor.ceriseRed.withOpacity(0.5)
                        : Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    '#$rank',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: rank! <= 3
                          ? AppColor.ceriseRed
                          : Colors.white.withOpacity(0.4),
                    ),
                  ),
                ),
              )
            else
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withOpacity(0.3),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
