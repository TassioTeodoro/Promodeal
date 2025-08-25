import 'package:flutter/material.dart';
import 'package:promodeal/models/user_model.dart';
import 'package:promodeal/services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _enderecoController = TextEditingController();

  bool _isComerciante = false;
  bool _isLoading = false;

  final _userService = UserService();

  Future<void> _finalizarSetup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;
      final userAuth = supabase.auth.currentUser;

      if (userAuth == null) {
        throw "Usuário não autenticado.";
      }

      final appUser = AppUser(
        id: userAuth.id,
        nome: _nomeController.text.trim(),
        email: userAuth.email ?? "",
        isComerciante: _isComerciante,
        cnpj: _isComerciante ? _cnpjController.text.trim() : null,
        endereco: _isComerciante ? _enderecoController.text.trim() : null,
      );

      await _userService.criarUsuario(appUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Configuração concluída com sucesso!")),
        );
        // TODO: redirecionar para tela principal
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black87),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 2),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Finalizar Configuração")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nomeController,
                  decoration: _inputDecoration("Nome de Usuário"),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Digite seu nome" : null,
                ),
                const SizedBox(height: 20),

                SwitchListTile(
                  title: const Text("Sou comerciante"),
                  value: _isComerciante,
                  onChanged: (val) => setState(() => _isComerciante = val),
                ),

                if (_isComerciante) ...[
                  TextFormField(
                    controller: _cnpjController,
                    decoration: _inputDecoration("CNPJ"),
                    validator: (value) {
                      if (_isComerciante &&
                          (value == null || value.isEmpty)) {
                        return "Digite o CNPJ";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _enderecoController,
                    decoration: _inputDecoration("Endereço"),
                    validator: (value) {
                      if (_isComerciante &&
                          (value == null || value.isEmpty)) {
                        return "Digite o endereço";
                      }
                      return null;
                    },
                  ),
                ],

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isLoading ? null : _finalizarSetup,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Finalizar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
