class BookModel {
  final String title;
  final String author;
  final double rating;
  final int reviewCount;
  final String genre;
  final String coverUrl;
  final String price;
  final bool isNew;
  final int rank;

  const BookModel({
    required this.title,
    required this.author,
    required this.rating,
    required this.reviewCount,
    required this.genre,
    required this.coverUrl,
    required this.price,
    this.isNew = false,
    required this.rank,
  });

  factory BookModel.fromJson(Map<String, dynamic> json, int index) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final saleInfo = json['saleInfo'] ?? {};

    return BookModel(
      title: volumeInfo['title'] ?? 'No Title',

      author:
          (volumeInfo['authors'] != null &&
              (volumeInfo['authors'] as List).isNotEmpty)
          ? volumeInfo['authors'][0]
          : 'Unknown',

      rating: (volumeInfo['averageRating'] ?? 0).toDouble(),

      reviewCount: volumeInfo['ratingsCount'] ?? 0,

      genre:
          (volumeInfo['categories'] != null &&
              (volumeInfo['categories'] as List).isNotEmpty)
          ? volumeInfo['categories'][0]
          : 'Unknown',

      coverUrl: volumeInfo['imageLinks']?['thumbnail'] ?? '',

      price: saleInfo['saleability'] == 'FREE' ? 'FREE' : 'N/A',

      isNew: BookModel._isNew(volumeInfo['publishedDate']),

      rank: index,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'rating': rating,
      'reviewCount': reviewCount,
      'genre': genre,
      'coverUrl': coverUrl,
      'price': price,
      'isNew': isNew,
      'rank': rank,
    };
  }

  static bool _isNew(String? date) {
    if (date == null) return false;

    try {
      final year = int.parse(date.substring(0, 4));
      return (DateTime.now().year - year) <= 2;
    } catch (_) {
      return false;
    }
  }
}



