import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import '../utils/validators.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = UserService();

  AppUser? _user;
  final _name = TextEditingController();
  final _address = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final u = await _service.getCurrentUser();
    if (u != null) {
      _name.text = u.nome;
      _address.text = u.endereco ?? '';
      if (mounted) setState(() => _user = u);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _user == null) return;
    final updated = AppUser(
      id: _user!.id,
      nome: _name.text.trim(),
      email: _user!.email,
      isComerciante: _user!.isComerciante,
      cnpj: _user!.cnpj,
      endereco: _address.text.trim(),
    );
    await _service.atualizarUsuario(updated);
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Conta atualizada')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações da Conta')),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (v) =>
                          Validators.requiredField(v, label: 'Nome'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _address,
                      decoration: const InputDecoration(labelText: 'Endereço'),
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
