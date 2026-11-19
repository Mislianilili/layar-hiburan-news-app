/// Satu chip di beranda: bisa kategori (/top-headlines) atau kata kunci (/search).
class NewsTopic {
  final String id; // dipakai sebagai kunci cache
  final String label;
  final String? category;
  final String? query;

  const NewsTopic.category(this.id, this.label, String this.category)
      : query = null;

  const NewsTopic.keyword(this.id, this.label, String this.query)
      : category = null;

  bool get isKeyword => query != null;

  /// Tema aplikasi: berita hiburan (drama dan film) Indonesia.
  static const List<NewsTopic> daftar = [
    NewsTopic.category('cat-entertainment', 'Hiburan', 'entertainment'),
    NewsTopic.keyword('q-drakor', 'Drama Korea', 'drama korea'),
    NewsTopic.keyword('q-film-id', 'Film Indonesia', 'film Indonesia'),
    NewsTopic.keyword('q-serial', 'Serial', 'serial OR series'),
    NewsTopic.keyword('q-bioskop', 'Bioskop', 'bioskop'),
    NewsTopic.keyword('q-artis', 'Artis', 'artis OR selebriti'),
  ];
}
