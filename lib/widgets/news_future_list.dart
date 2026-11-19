import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/article_model.dart';
import '../routes/app_routes.dart';
import 'article_card.dart';
import 'error_view.dart';

/// Daftar berita dengan FutureBuilder dan empat state:
/// loading, error, kosong, data. Dipakai oleh HomeView dan SearchResultView.
/// Future-nya DIPEGANG oleh State pemanggil (bukan dibuat di sini / di build()).
class NewsFutureList extends StatelessWidget {
  final Future<List<ArticleModel>> future;
  final VoidCallback onRetry;
  final Future<void> Function() onRefresh;
  final String emptyText;

  const NewsFutureList({
    super.key,
    required this.future,
    required this.onRetry,
    required this.onRefresh,
    this.emptyText = 'Belum ada berita.',
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArticleModel>>(
      future: future,
      builder: (context, snapshot) {
        // 1) Loading
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        // 2) Error
        if (snapshot.hasError) {
          return ErrorView(message: snapshot.error.toString(), onRetry: onRetry);
        }
        // 3) Kosong (dibuat scrollable agar pull-to-refresh tetap bisa)
        final articles = snapshot.data ?? [];
        if (articles.isEmpty) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 300,
                  child: Center(child: Text(emptyText)),
                ),
              ],
            ),
          );
        }
        // 4) Data
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return ArticleCard(
                article: article,
                onTap: () => Get.toNamed(AppRoutes.detail, arguments: article),
              );
            },
          ),
        );
      },
    );
  }
}
