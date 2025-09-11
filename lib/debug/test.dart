import 'package:flutter/material.dart';
import 'package:promodeal/models/comentario_model.dart';
import 'package:promodeal/models/user_model.dart';
import 'package:promodeal/models/promocao_model.dart';
import 'package:promodeal/services/user_service.dart';
import 'package:promodeal/services/promocao_service.dart';
import 'package:promodeal/services/comentario_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final _userService = UserService();
  final _promoService = PromocaoService();
  final _comentarioService = ComentarioService();

  String _log = "";

  void _logMsg(String msg) {
    setState(() {
      _log += "$msg\n";
    });
  }

  Future<void> _testUsuario() async {
    try {
      _logMsg("🔹 Criando usuário...");
      final supabase = Supabase.instance.client;


      final user = AppUser(
        id: "Id Teste",
        nome: "Usuário Teste",
        email: "teste@teste.com",
        isComerciante: true,
        cnpj: "12345678000199",
        endereco: "Rua Teste, 123",
      );

      await _userService.criarUsuario(user);
      _logMsg("✅ Usuário criado: ${user.toMap()}");

      final lista = await _userService.listarUsuarios();
      _logMsg("📋 Usuários no banco: ${lista.length}");
    } catch (e) {
      _logMsg("❌ Erro em _testUsuario: $e");
    }
  }

  Future<void> _testPromocao() async {
    try {
      _logMsg("🔹 Criando promoção...");
      final supabase = Supabase.instance.client;
      final promocao = Promocao(
        idUsuario: "Id Teste",
        descricao: "Promoção Teste",
        precoDe: 100,
        precoPor: 80,
        tags: ["tag1", "tag2"],
        dataPublicacao: DateTime.now(),
        imagemUrl: null,
      );

      await _promoService.criarPromocao(promocao);
      _logMsg("✅ Promoção criada: ${promocao.toMap()}");

      final lista = await _promoService.listarPromocoesComUsuarios();
      _logMsg("📋 Promoções no banco: ${lista.length}");
    } catch (e) {
      _logMsg("❌ Erro em _testPromocao: $e");
    }
  }

  Future<void> _testComentario() async {
  try {
    _logMsg("🔹 Criando comentário...");
    final supabase = Supabase.instance.client;
    final userAuth = supabase.auth.currentUser;
    if (userAuth == null) {
      _logMsg("⚠️ Nenhum usuário autenticado!");
      return;
    }

    // pega a primeira promoção existente
    final promocoes = await _promoService.listarPromocoesComUsuarios();
    if (promocoes.isEmpty) {
      _logMsg("⚠️ Nenhuma promoção encontrada para comentar.");
      return;
    }
    final idPromocao = promocoes.first["id"] as String;

    final comentario = Comentario(
      idUsuario: "Id Teste",
      idPromocao: idPromocao,
      conteudo: "Comentário de teste",
    );

    await _comentarioService.criarComentario(comentario);
    _logMsg("✅ Comentário criado: ${comentario.toMap()}");

    final lista = await _comentarioService.listarComentariosPorPromocao(idPromocao);
    _logMsg("📋 Comentários nessa promoção: ${lista.length}");
  } catch (e) {
    _logMsg("❌ Erro em _testComentario: $e");
  }
}

  void _limparLog() {
    setState(() => _log = "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tela de Testes")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _testUsuario,
                  child: const Text("Testar Usuário"),
                ),
                ElevatedButton(
                  onPressed: _testPromocao,
                  child: const Text("Testar Promoção"),
                ),
                ElevatedButton(
                  onPressed: _testComentario,
                  child: const Text("Testar Comentário"),
                ),
                ElevatedButton(
                  onPressed: _limparLog,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Limpar Log"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _log,
                  style: const TextStyle(fontFamily: "monospace"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
