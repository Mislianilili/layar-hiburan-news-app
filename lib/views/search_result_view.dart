import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/article_model.dart';
import '../services/news_api_service.dart';
import '../utils/app_colors.dart';
import '../widgets/news_future_list.dart';

class SearchResultView extends StatefulWidget {
  const SearchResultView({super.key});

  @override
  State<SearchResultView> createState() => _SearchResultViewState();
}

class _SearchResultViewState extends State<SearchResultView> {
  final NewsApiService _service = NewsApiService();
  late final String _keyword;
  late Future<List<ArticleModel>> _futureNews;

  @override
  void initState() {
    super.initState();
    _keyword = Get.arguments as String;
    _futureNews = _service.searchNews(_keyword);
  }

  void _muatUlang() {
    setState(() {
      _futureNews = _service.searchNews(_keyword);
    });
  }

  Future<void> _onRefresh() async {
    _muatUlang();
    try {
      await _futureNews;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Hasil: $_keyword', overflow: TextOverflow.ellipsis),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: NewsFutureList(
        future: _futureNews,
        onRetry: _muatUlang,
        onRefresh: _onRefresh,
        emptyText: 'Tidak ada berita untuk "$_keyword".',
      ),
    );
  }
}
