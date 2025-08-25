import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool _isLoading = false;

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final senha = _senhaController.text.trim();

      final supabase = Supabase.instance.client;

      // Faz o signup no Supabase Auth
      final response = await supabase.auth.signUp(
        email: email,
        password: senha,
      );

      if (response.user != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Conta criada com sucesso! Verifique seu email.")),
          );
          Navigator.pop(context); // volta para a tela anterior
        }
      } else {
        throw "Erro desconhecido ao criar conta.";
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: ${e.message}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro inesperado: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputDecoration(String label, {String? helper}) {
    return InputDecoration(
      labelText: label,
      helperText: helper,
      helperStyle: const TextStyle(color: Colors.green),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Placeholder da Logo
                Container(
                  height: 120,
                  width: 120,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Text(
                    "Logo",
                    style: TextStyle(color: Colors.black54),
                  ),
                ),

                const SizedBox(height: 40),

                // Campo Email
                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration("Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Digite seu email";
                    }
                    if (!value.contains("@")) {
                      return "Email inválido";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Campo Senha
                TextFormField(
                  controller: _senhaController,
                  decoration: _inputDecoration(
                    "Senha",
                    helper: "Use 8 ou mais caracteres",
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return "A senha deve ter no mínimo 8 caracteres";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Campo Confirmar Senha
                TextFormField(
                  controller: _confirmarSenhaController,
                  decoration: _inputDecoration("Confirmar Senha"),
                  obscureText: true,
                  validator: (value) {
                    if (value != _senhaController.text) {
                      return "As senhas não conferem";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // Botão Cadastrar
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
                    onPressed: _isLoading ? null : _cadastrar,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Cadastrar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
