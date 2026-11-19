import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/article_model.dart';

class DetailController extends GetxController {
  final ArticleModel article = Get.arguments as ArticleModel;

  Future<void> salinTautan() async {
    final url = article.url;
    if (url == null) return;
    await Clipboard.setData(ClipboardData(text: url));
    Get.snackbar('Tersalin', 'Tautan berita disalin ke clipboard',
        snackPosition: SnackPosition.BOTTOM);
  }
}
