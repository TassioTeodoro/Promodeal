import 'package:flutter/material.dart';
import '../services/promocao_service.dart';
import '../models/promocao_model.dart';
import '../widgets/promotion_card.dart';
import '../routes.dart';

class HomeClientScreen extends StatefulWidget {
  const HomeClientScreen({super.key});

  @override
  State<HomeClientScreen> createState() => _HomeClientScreenState();
}

class _HomeClientScreenState extends State<HomeClientScreen> {
  final _service = PromocaoService();
  List<Promocao> _items = [];
  bool _loading = true;

  Future<void> _load([String? q]) async {
    setState(() => _loading = true);
    _items = await _service.listActive(query: q);
    if (mounted) setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promoções'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, Routes.search),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, Routes.account),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (_, i) => PromotionCard(promo: _items[i]),
              ),
            ),
    );
  }
}
