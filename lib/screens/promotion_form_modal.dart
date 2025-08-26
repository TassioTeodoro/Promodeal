import 'package:flutter/material.dart';
import '../models/promocao_model.dart';
import '../services/promocao_service.dart';
import '../utils/validators.dart';

class PromotionFormModal extends StatefulWidget {
  final Promocao? initial;
  const PromotionFormModal({super.key, this.initial});

  @override
  State<PromotionFormModal> createState() => _PromotionFormModalState();
}

class _PromotionFormModalState extends State<PromotionFormModal> {
  final _formKey = GlobalKey<FormState>();
  final _service = PromocaoService();

  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  final _discount = TextEditingController(text: '0');
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now().add(const Duration(days: 7));

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    if (p != null) {
      _title.text = p.titulo;
      _desc.text = p.descricao;
      _price.text = p.preco.toStringAsFixed(2);
      _discount.text = p.desconto.toStringAsFixed(0);
      _start = p.startAt;
      _end = p.endAt;
    }
  }

  Future<void> _pickDate({required bool start}) async {
    final current = start ? _start : _end;
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => start ? _start = picked : _end = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();

    final p = Promocao(
      id:
          widget.initial?.id ??
          '', // deixe vazio para insert (ver ajuste no service abaixo)
      titulo: _title.text.trim(),
      descricao: _desc.text.trim(),
      preco: double.tryParse(_price.text.replaceAll(',', '.')) ?? 0,
      desconto: double.tryParse(_discount.text) ?? 0,
      startAt: _start,
      endAt: _end,
      comercianteId: 'current-merchant',
      dataCriacao: widget.initial?.dataCriacao ?? now,
      dataAgendamento: widget.initial?.dataAgendamento,
      imagemUrl:
          widget.initial?.imagemUrl ?? '', // placeholder até integrar upload
    );

    if (widget.initial == null) {
      await _service.criarPromocao(p);
    } else {
      await _service.atualizarPromocao(p);
    }
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.initial == null ? 'Nova Promoção' : 'Editar Promoção',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => Validators.requiredField(v, label: 'Título'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _desc,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _price,
                      decoration: const InputDecoration(labelText: 'Preço (R)'),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (v) =>
                          Validators.requiredField(v, label: 'Preço'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _discount,
                      decoration: const InputDecoration(
                        labelText: 'Desconto (%)',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Início'),
                      subtitle: Text(
                        '${_start.day}/${_start.month}/${_start.year}',
                      ),
                      onTap: () => _pickDate(start: true),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Fim'),
                      subtitle: Text('${_end.day}/${_end.month}/${_end.year}'),
                      onTap: () => _pickDate(start: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: _save, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
