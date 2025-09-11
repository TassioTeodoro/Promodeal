import 'package:flutter/material.dart';
import 'package:promodeal/models/user_model.dart';
import 'package:promodeal/services/user_service.dart';

class ProfileEditScreen extends StatefulWidget {
  final AppUser usuario;

  const ProfileEditScreen({super.key, required this.usuario});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userService = UserService();

  late TextEditingController _nomeController;
  late TextEditingController _bioController;
  late TextEditingController _enderecoController;


  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.usuario.nome);
    _bioController = TextEditingController(text: widget.usuario.bio ?? '');
    _enderecoController =
        TextEditingController(text: widget.usuario.endereco ?? '');
  }

  Future<void> _salvar() async {
    final atualizado = AppUser(
      id: widget.usuario.id,
      nome: _nomeController.text,
      email: widget.usuario.email,
      bio: _bioController.text.isEmpty ? null : _bioController.text,
      endereco: _enderecoController.text.isEmpty ? null : _enderecoController.text,
      isComerciante: widget.usuario.isComerciante,
    );

    await _userService.atualizarUsuario(atualizado);

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Perfil"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Nome"),
              ),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: "Bio"),
                maxLines: 3,
              ),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(labelText: "Endereço"),
              ),
              const SizedBox(height: 20),
              FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateColor.resolveWith((states) => Colors.green,)
                ),
                onPressed: _salvar,
                child: const Text("Salvar"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
