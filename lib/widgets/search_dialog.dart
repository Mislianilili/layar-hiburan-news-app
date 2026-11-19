import 'package:flutter/material.dart';

/// Dialog input kata kunci. Mengembalikan String lewat Navigator.pop.
class SearchDialog extends StatefulWidget {
  const SearchDialog({super.key});

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _kirim() {
    final kata = _controller.text.trim();
    if (kata.isEmpty) {
      setState(() => _errorText = 'Kata kunci tidak boleh kosong');
      return;
    }
    Navigator.of(context).pop(kata);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cari Berita'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 100,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => _kirim(),
        decoration: InputDecoration(
          hintText: 'Contoh: drama korea',
          errorText: _errorText,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(onPressed: _kirim, child: const Text('Cari')),
      ],
    );
  }
}
