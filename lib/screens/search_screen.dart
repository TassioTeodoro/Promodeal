import 'package:flutter/material.dart';
import '../services/promocao_service.dart';
import '../models/promocao_model.dart';
import '../widgets/promotion_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _queryCtrl = TextEditingController();
  final _service = PromocaoService();
  List<Promocao> _items = [];
  bool _loading = false;

  Future<void> _search() async {
    setState(() => _loading = true);
    _items = await _service.listActive(query: _queryCtrl.text.trim());
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _queryCtrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Buscar promoções...'),
          onSubmitted: (_) => _search(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: _search),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (_, i) => PromotionCard(promo: _items[i]),
            ),
    );
  }
}
