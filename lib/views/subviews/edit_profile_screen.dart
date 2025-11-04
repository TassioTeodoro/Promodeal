import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:promodeal/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileEditScreen extends StatefulWidget {
  final AppUser usuario;

  const ProfileEditScreen({super.key, required this.usuario});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final _supabase = Supabase.instance.client;

  late TextEditingController _nomeController;
  late TextEditingController _bioController;
  late TextEditingController _enderecoController;

  String? _fotoUrl = "";
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.usuario.nome);
    _bioController = TextEditingController(text: widget.usuario.bio ?? '');
    _enderecoController =
        TextEditingController(text: widget.usuario.endereco ?? '');
    _fotoUrl = widget.usuario.pfpUrl;
  }

  /// 🔹 Pick an image and upload directly to Supabase using XFile
  Future<void> _selecionarImagem() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    setState(() => _uploading = true);

    try {
      final ext = picked.name.split('.').last;
      final fileName = 'perfil_$userId.$ext';
      final filePath = 'avatars/$fileName';

      // 🔸 Upload XFile bytes directly
      final bytes = await picked.readAsBytes();
      await _supabase.storage.from('profilepictures').uploadBinary(
            filePath,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );

      // 🔸 Get public URL
      final publicUrl =
          _supabase.storage.from('profilepictures').getPublicUrl(filePath);

      // 🔸 Update user table
      await _supabase
          .from('usuarios')
          .update({'pfp_url': publicUrl}).eq('id', userId);

      setState(() {
        _fotoUrl = publicUrl;
        _uploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagem de perfil atualizada!')),
      );
    } catch (e) {
      setState(() => _uploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar imagem: $e')),
      );
    }
  }

  /// 🔹 Save text fields (nome, bio, endereco)
  Future<void> _salvarPerfil() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _supabase.from('usuarios').update({
        'nome': _nomeController.text,
        'bio': _bioController.text.isEmpty ? null : _bioController.text,
        'endereco':
            _enderecoController.text.isEmpty ? null : _enderecoController.text,
      }).eq('id', userId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar perfil: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Perfil"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _fotoUrl != null
                        ? NetworkImage(_fotoUrl!)
                        : const AssetImage('assets/avatar_placeholder.png')
                            as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _uploading ? null : _selecionarImagem,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.green,
                        child: _uploading
                            ? const CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2)
                            : const Icon(Icons.camera_alt,
                                color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: "Bio",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _enderecoController,
              decoration: const InputDecoration(
                labelText: "Endereço",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _uploading ? null : _salvarPerfil,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text("Salvar Alterações",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
