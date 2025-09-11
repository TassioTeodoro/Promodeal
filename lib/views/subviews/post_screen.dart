import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:promodeal/models/promocao_model.dart';
import 'package:promodeal/models/user_model.dart';
import 'package:promodeal/services/promocao_service.dart';
import 'package:promodeal/services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/v4.dart';

class PublishPromotionScreen extends StatefulWidget {
  const PublishPromotionScreen({super.key});

  @override
  State<PublishPromotionScreen> createState() => _PublishPromotionScreenState();
}

class _PublishPromotionScreenState extends State<PublishPromotionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _precoDeController = TextEditingController();
  final _precoPorController = TextEditingController();
  final _tagController = TextEditingController();

  DateTime? _dataPublicacao = DateTime.now();
  List<String> _tags = [];
  String? _imagemUrl;

  AppUser? _usuario;
  bool _isLoading = false;

  final _userService = UserService();
  final _promoService = PromocaoService();
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  Future<void> _carregarUsuario() async {
    final supabase = Supabase.instance.client;
    final userAuth = supabase.auth.currentUser;
    if (userAuth != null) {
      final usuario = await _userService.buscarUsuarioPorId(userAuth.id);
      setState(() => _usuario = usuario);
    }
  }

  Future<void> _selecionarImagem() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    try {
      final supabase = Supabase.instance.client;
      final fileBytes = await file.readAsBytes();
      final fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}";

      await supabase.storage
          .from("promocoes")
          .uploadBinary(
            fileName,
            fileBytes,
            fileOptions: const FileOptions(upsert: true),
          );

      final urlResponse = supabase.storage
          .from("promocoes")
          .getPublicUrl(fileName);

      setState(() => _imagemUrl = urlResponse);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro ao enviar imagem: $e")));
      }
    }
  }

  Future<void> _publicar() async {
    if (!_formKey.currentState!.validate() || _usuario == null) return;

    setState(() => _isLoading = true);

    try {
      final novaPromocao = Promocao(
        id: UuidV4().generate(),
        idUsuario: _usuario!.id,
        descricao: _descricaoController.text.trim(),
        precoDe: double.tryParse(_precoDeController.text.trim()) ?? 0,
        precoPor: double.tryParse(_precoPorController.text.trim()) ?? 0,
        tags: _tags,
        dataPublicacao: _dataPublicacao,
        imagemUrl: _imagemUrl,
      );

      await _promoService.criarPromocao(novaPromocao);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Promoção publicada com sucesso!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erro: $e")));
      }
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
    if (_usuario == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Nova Promoção")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header com avatar + nome da loja
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey[400],
                          child: const Icon(Icons.store, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _usuario!.nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Descrição
                    TextFormField(
                      controller: _descricaoController,
                      decoration: _inputDecoration("Conteúdo da Postagem"),
                      maxLines: 3,
                      validator: (value) => value == null || value.isEmpty
                          ? "Digite uma descrição"
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Botão anexos
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: _selecionarImagem,
                        child: const Text(
                          "Adicionar Anexos",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    if (_imagemUrl != null) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _imagemUrl!,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),

                    // Preço De
                    TextFormField(
                      controller: _precoDeController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration("De:"),
                    ),
                    const SizedBox(height: 16),

                    // Preço Por
                    TextFormField(
                      controller: _precoPorController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration("Por:"),
                    ),
                    const SizedBox(height: 16),

                    // Tags
                    const Text("Tags"),
                    Wrap(
                      spacing: 6,
                      children: _tags
                          .map(
                            (t) => Chip(
                              label: Text(
                                t,
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.green,
                              deleteIcon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onDeleted: () {
                                setState(() => _tags.remove(t));
                              },
                            ),
                          )
                          .toList(),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _tagController,
                            decoration: const InputDecoration(
                              hintText: "Nova tag",
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.green),
                          onPressed: () {
                            if (_tagController.text.trim().isNotEmpty) {
                              setState(() {
                                _tags.add(_tagController.text.trim());
                                _tagController.clear();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Data de publicação
                    TextFormField(
                      readOnly: true,
                      decoration: _inputDecoration("Publicar Em").copyWith(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final data = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (data != null) {
                              final hora = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (hora != null) {
                                setState(() {
                                  _dataPublicacao = DateTime(
                                    data.year,
                                    data.month,
                                    data.day,
                                    hora.hour,
                                    hora.minute,
                                  );
                                });
                              }
                            }
                          },
                        ),
                      ),
                      controller: TextEditingController(
                        text: _dataPublicacao.toString(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Botão confirmar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: _isLoading ? null : _publicar,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Confirmar",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
