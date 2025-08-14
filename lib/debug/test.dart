import 'package:flutter/material.dart';
import 'package:promodeal/models/user_model.dart';
import 'package:promodeal/models/promocao_model.dart';
import 'package:promodeal/models/comentario_model.dart';
import 'package:promodeal/services/user_service.dart';
import 'package:promodeal/services/promocao_service.dart';
import 'package:promodeal/services/comentario_service.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final UserService _userService = UserService();
  final PromocaoService _promocaoService = PromocaoService();
  final ComentarioService _comentarioService = ComentarioService();

  String _log = '';

  void _addLog(String msg) {
    setState(() {
      _log += "$msg\n";
    });
  }

  /// Teste CRUD de Usuário (isolado)
  Future<void> _testUserCRUD() async {
    try {
      const userId = "debug-user";
      final user = AppUser(
        id: userId,
        nome: "Usuário Debug",
        email: "debug@example.com",
        isComerciante: false,
      );

      _addLog("📤 Criando usuário...");
      await _userService.criarUsuario(user);
      _addLog("✅ Usuário criado.");

      _addLog("📤 Buscando usuário...");
      final fetched = await _userService.buscarUsuarioPorId(userId);
      _addLog("🔍 Encontrado: ${fetched?.toMap()}");

      _addLog("📤 Atualizando usuário...");
      await _userService.atualizarUsuario(
        AppUser(
          id: userId,
          nome: "Usuário Atualizado",
          email: "debug@example.com",
          isComerciante: true,
        ),
      );
      _addLog("✅ Usuário atualizado.");

      _addLog("📤 Deletando usuário...");
      await _userService.deletarUsuario(userId);
      _addLog("✅ Usuário deletado.");
    } catch (e, st) {
      _addLog("❌ ERRO UserService: $e");
      debugPrintStack(stackTrace: st);
    }
  }

  /// Teste CRUD de Promoção (criando usuário antes)
  Future<void> _testPromocaoCRUD() async {
    const userId = "debug-user";
    const promoId = "debug-promo";

    try {
      // Criar usuário para o comerciante
      final user = AppUser(
        id: userId,
        nome: "Comerciante Debug",
        email: "comerciante@example.com",
        isComerciante: true,
      );
      _addLog("📤 Criando comerciante...");
      await _userService.criarUsuario(user);

      // Criar promoção vinculada ao comerciante
      final promo = Promocao(
        id: promoId,
        titulo: "Promoção Debug",
        descricao: "Teste CRUD Promoção",
        preco: 100.0,
        desconto: 20.0,
        comercianteId: userId,
        dataCriacao: DateTime.now(),
        imagemUrl: "https://via.placeholder.com/150",
      );
      _addLog("📤 Criando promoção...");
      await _promocaoService.criarPromocao(promo);
      _addLog("✅ Promoção criada.");

      _addLog("📤 Listando promoções...");
      final list = await _promocaoService.listarPromocoes();
      _addLog("📋 Lista: ${list.map((p) => p.toMap()).toList()}");

      _addLog("📤 Atualizando promoção...");
      await _promocaoService.atualizarPromocao(
        Promocao(
          id: promoId,
          titulo: "Promoção Atualizada",
          descricao: "Descrição nova",
          preco: 150.0,
          desconto: 10.0,
          comercianteId: userId,
          dataCriacao: DateTime.now(),
          imagemUrl: "https://via.placeholder.com/300",
        ),
      );
      _addLog("✅ Promoção atualizada.");

      // Remover tudo na ordem correta
      _addLog("📤 Deletando promoção...");
      await _promocaoService.deletarPromocao(promoId);

      _addLog("📤 Deletando comerciante...");
      await _userService.deletarUsuario(userId);
      _addLog("✅ Teste promoção concluído.");
    } catch (e, st) {
      _addLog("❌ ERRO PromocaoService: $e");
      debugPrintStack(stackTrace: st);
    }
  }

  /// Teste CRUD de Comentário (criando usuário e promoção antes)
  Future<void> _testComentarioCRUD() async {
    const userId = "debug-user";
    const promoId = "debug-promo";
    const commentId = "debug-comment";

    try {
      // Criar usuário
      final user = AppUser(
        id: userId,
        nome: "Usuário Debug",
        email: "user@example.com",
        isComerciante: false,
      );
      _addLog("📤 Criando usuário...");
      await _userService.criarUsuario(user);

      // Criar comerciante (pra ter promoção)
      final comerciante = AppUser(
        id: "debug-comerciante",
        nome: "Comerciante Debug",
        email: "comerciante@example.com",
        isComerciante: true,
      );
      _addLog("📤 Criando comerciante...");
      await _userService.criarUsuario(comerciante);

      // Criar promoção
      final promo = Promocao(
        id: promoId,
        titulo: "Promoção Debug",
        descricao: "Promoção para teste de comentário",
        preco: 50.0,
        desconto: 5.0,
        comercianteId: "debug-comerciante",
        dataCriacao: DateTime.now(),
        imagemUrl: "https://via.placeholder.com/150",
      );
      _addLog("📤 Criando promoção...");
      await _promocaoService.criarPromocao(promo);

      // Criar comentário
      final comment = Comentario(
        id: commentId,
        promocaoId: promoId,
        usuarioId: userId,
        texto: "Comentário teste",
        dataComentario: DateTime.now(),
      );
      _addLog("📤 Criando comentário...");
      await _comentarioService.criarComentario(comment);
      _addLog("✅ Comentário criado.");

      _addLog("📤 Listando comentários...");
      final list = await _comentarioService.listarComentariosPorPromocao(promoId);
      _addLog("📋 Lista: ${list.map((c) => c.toMap()).toList()}");

      // Remover tudo na ordem inversa
      _addLog("📤 Deletando comentário...");
      await _comentarioService.deletarComentario(commentId);

      _addLog("📤 Deletando promoção...");
      await _promocaoService.deletarPromocao(promoId);

      _addLog("📤 Deletando comerciante...");
      await _userService.deletarUsuario("debug-comerciante");

      _addLog("📤 Deletando usuário...");
      await _userService.deletarUsuario(userId);

      _addLog("✅ Teste comentário concluído.");
    } catch (e, st) {
      _addLog("❌ ERRO ComentarioService: $e");
      debugPrintStack(stackTrace: st);
    }
  }

  void _clearLog() => setState(() => _log = '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tela de Testes Services")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _testUserCRUD,
                  child: const Text("Testar Usuário CRUD"),
                ),
                ElevatedButton(
                  onPressed: _testPromocaoCRUD,
                  child: const Text("Testar Promoção CRUD"),
                ),
                ElevatedButton(
                  onPressed: _testComentarioCRUD,
                  child: const Text("Testar Comentário CRUD"),
                ),
                ElevatedButton(
                  onPressed: _clearLog,
                  child: const Text("Limpar Log"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _log,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
