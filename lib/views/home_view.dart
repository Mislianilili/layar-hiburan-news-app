import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/article_model.dart';
import '../models/news_topic.dart';
import '../routes/app_routes.dart';
import '../services/news_api_service.dart';
import '../utils/app_colors.dart';
import '../widgets/news_future_list.dart';
import '../widgets/search_dialog.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final NewsApiService _service = NewsApiService();

  /// Hemat kuota: Future tiap topik disimpan, kembali ke chip yang sama
  /// tidak memicu request baru.
  final Map<String, Future<List<ArticleModel>>> _cache = {};

  NewsTopic _selected = NewsTopic.daftar.first;

  /// Future disimpan di State, BUKAN dibuat di dalam build()
  late Future<List<ArticleModel>> _futureNews;

  @override
  void initState() {
    super.initState();
    _futureNews = _ambil(_selected);
  }

  Future<List<ArticleModel>> _ambil(NewsTopic topic) {
    final tersimpan = _cache[topic.id];
    if (tersimpan != null) return tersimpan;

    final future = topic.isKeyword
        ? _service.searchNews(topic.query!)
        : _service.getTopHeadlines(category: topic.category!);
    _cache[topic.id] = future;

    // Future yang gagal dibuang dari cache supaya "Coba Lagi" benar-benar request ulang
    future.catchError((_) {
      if (identical(_cache[topic.id], future)) _cache.remove(topic.id);
      return <ArticleModel>[];
    });
    return future;
  }

  /// Dipakai tombol Coba Lagi dan pull-to-refresh: buang cache, minta data baru.
  void _muatUlang() {
    setState(() {
      _cache.remove(_selected.id);
      _futureNews = _ambil(_selected);
    });
  }

  void _gantiTopik(NewsTopic topic) {
    if (topic.id == _selected.id) return;
    setState(() {
      _selected = topic;
      _futureNews = _ambil(topic); // dari cache bila sudah pernah dimuat
    });
  }

  Future<void> _onRefresh() async {
    _muatUlang();
    try {
      await _futureNews;
    } catch (_) {
      // error sudah ditampilkan oleh FutureBuilder
    }
  }

  Future<void> _bukaPencarian() async {
    final kata = await showDialog<String>(
      context: context,
      builder: (_) => const SearchDialog(),
    );
    if (kata != null && kata.isNotEmpty) {
      Get.toNamed(AppRoutes.searchResult, arguments: kata);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Layar Hiburan'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Cari berita',
            icon: const Icon(Icons.search),
            onPressed: _bukaPencarian,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTopicChips(),
          Expanded(
            child: NewsFutureList(
              future: _futureNews,
              onRetry: _muatUlang,
              onRefresh: _onRefresh,
              emptyText: 'Belum ada berita untuk topik ini.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicChips() {
    return Container(
      height: 56,
      color: AppColors.surface,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: NewsTopic.daftar.length,
        itemBuilder: (context, index) {
          final topic = NewsTopic.daftar[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: ChoiceChip(
              label: Text(topic.label),
              selected: topic.id == _selected.id,
              onSelected: (_) => _gantiTopik(topic),
            ),
          );
        },
      ),
    );
  }
}
