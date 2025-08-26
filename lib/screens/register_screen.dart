import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../routes.dart';
import '../utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _cnpjCtrl = TextEditingController();
  final _addrCtrl = TextEditingController();

  bool _isMerchant = false;
  bool _loading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final user = await _auth.signUp(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
        isMerchant: _isMerchant,
        cnpj: _isMerchant ? _cnpjCtrl.text.trim() : null,
        address: _isMerchant ? _addrCtrl.text.trim() : null,
      );
      if (!mounted) return;
      if (user == null) throw Exception('Falha ao cadastrar');
      Navigator.pushReplacementNamed(
        context,
        _isMerchant ? Routes.homeMerchant : Routes.homeClient,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (v) => Validators.requiredField(v, label: 'Nome'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: Validators.email,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passCtrl,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: Validators.password,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                value: _isMerchant,
                title: const Text('Sou Comerciante'),
                onChanged: (v) => setState(() => _isMerchant = v),
              ),
              if (_isMerchant) ...[
                TextFormField(
                  controller: _cnpjCtrl,
                  decoration: const InputDecoration(labelText: 'CNPJ'),
                  validator: Validators.cnpj,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addrCtrl,
                  decoration: const InputDecoration(labelText: 'Endereço'),
                ),
              ],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Criar conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
