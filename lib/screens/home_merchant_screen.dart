import 'package:flutter/material.dart';
import '../services/promocao_service.dart';
import '../models/promocao_model.dart';
import '../widgets/promotion_card.dart';
import 'promotion_form_modal.dart';

class HomeMerchantScreen extends StatefulWidget {
  const HomeMerchantScreen({super.key});

  @override
  State<HomeMerchantScreen> createState() => _HomeMerchantScreenState();
}

class _HomeMerchantScreenState extends State<HomeMerchantScreen> {
  final _service = PromocaoService();
  List<Promocao> _items = [];
  bool _loading = true;

  Future<void> _load() async {
    setState(() => _loading = true);
    _items = await _service.listarPromocoesPorMerchant('current-merchant');
    if (mounted) setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _openCreate() async {
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const PromotionFormModal(),
    );
    if (created == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Promoções')),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreate,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (_, i) => PromotionCard(
                  promo: _items[i],
                  onEdit: () => _openCreate(), // TODO: versão editar
                  onDelete: () async {
                    await _service.deletarPromocao(_items[i].id);
                    if (mounted) _load();
                  },
                ),
              ),
            ),
    );
  }
}
