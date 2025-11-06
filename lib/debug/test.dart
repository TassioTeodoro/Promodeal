import 'package:flutter/material.dart';
import 'package:promodeal/models/user_model.dart';
import 'package:promodeal/models/promocao_model.dart';
import 'package:promodeal/models/comentario_model.dart';
import 'package:promodeal/services/user_service.dart';
import 'package:promodeal/services/promocao_service.dart';
import 'package:promodeal/services/comentario_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  void _limparLog() {
    setState(() => _log = "");
  }

  // 🔹 Teste: Usuário
  Future<void> _testUsuario() async {
    try {
      _logMsg("🔹 Criando usuário...");
      final supabase = Supabase.instance.client;
      final userAuth = supabase.auth.currentUser;

      if (userAuth == null) {
        _logMsg("⚠️ Nenhum usuário autenticado! Faça login antes de testar.");
        return;
      }

      // safe access: userAuth não é nulo aqui
      final user = AppUser(
        id: userAuth.id,
        nome: "Usuário Teste",
        email: userAuth.email ?? "teste@teste.com",
        isComerciante: true,
        cnpj: "12345678000199",
        endereco: "Rua dos Testes, 123",
        bio: "Usuário criado para teste automático",
        pfpUrl: null,
      );

      await _userService.criarUsuario(user);
      _logMsg("✅ Usuário criado com sucesso: ${user.toMap()}");

      final lista = await _userService.listarUsuarios();
      _logMsg("📋 Total de usuários no banco: ${lista.length}");
    } catch (e, st) {
      _logMsg("❌ Erro em _testUsuario: $e");
      _logMsg("$st");
    }
  }

  // 🔹 Teste: Promoção
  Future<void> _testPromocao() async {
    try {
      _logMsg("🔹 Criando promoção...");
      final supabase = Supabase.instance.client;
      final userAuth = supabase.auth.currentUser;

      if (userAuth == null) {
        _logMsg("⚠️ Nenhum usuário autenticado! Faça login antes de testar.");
        return;
      }

      final promocao = Promocao(
        idUsuario: userAuth.id,
        descricao: "Promoção de Teste Automático",
        precoDe: 150.0,
        precoPor: 99.9,
        tags: ["teste", "promo", "flutter"],
        dataPublicacao: DateTime.now(),
        imagemUrl: null,
      );

      await _promoService.criarPromocao(promocao);
      _logMsg("✅ Promoção criada com sucesso: ${promocao.toMap()}");

      final lista = await _promoService.listarPromocoesComUsuarios();
      _logMsg(
        "📋 Total de promoções (com join usuarios) no banco: ${lista.length}",
      );
    } catch (e, st) {
      _logMsg("❌ Erro em _testPromocao: $e");
      _logMsg("$st");
    }
  }

  // 🔹 Teste: Comentário
  Future<void> _testComentario() async {
    try {
      _logMsg("🔹 Criando comentário...");
      final supabase = Supabase.instance.client;
      final userAuth = supabase.auth.currentUser;

      if (userAuth == null) {
        _logMsg("⚠️ Nenhum usuário autenticado! Faça login antes de testar.");
        return;
      }

      final promocoes = await _promoService.listarPromocoes();
      if (promocoes.isEmpty) {
        _logMsg("⚠️ Nenhuma promoção encontrada para comentar!");
        return;
      }

      final primeira = promocoes.first;
      final idPromocao = primeira.id;
      if (idPromocao == null) {
        _logMsg(
          "⚠️ A primeira promoção não tem id (null). Não é possível comentar.",
        );
        return;
      }

      final comentario = Comentario(
        idUsuario: userAuth.id,
        idPromocao: idPromocao,
        conteudo: "Comentário gerado automaticamente para teste",
      );

      await _comentarioService.criarComentario(comentario);
      _logMsg("✅ Comentário criado: ${comentario.toMap()}");

      final lista = await _comentario_service_listSafe(
        idPromocao,
      ); // wrapper para evitar conflito de nomes
      _logMsg("📋 Total de comentários nessa promoção: ${lista.length}");
    } catch (e, st) {
      _logMsg("❌ Erro em _testComentario: $e");
      _logMsg("$st");
    }
  }

  // wrapper para manter o estilo do seu service
  Future<List<Comentario>> _comentario_service_listSafe(
    String promocaoId,
  ) async {
    return await _comentarioService.listarComentariosPorPromocao(promocaoId);
  }

  // 🔹 Teste: Likes
  Future<void> _testLike() async {
    try {
      _logMsg("🔹 Testando sistema de likes...");
      final supabase = Supabase.instance.client;
      final userAuth = supabase.auth.currentUser;

      if (userAuth == null) {
        _logMsg("⚠️ Nenhum usuário autenticado! Faça login antes de testar.");
        return;
      }

      final promocoes = await _promoService.listarPromocoes();
      if (promocoes.isEmpty) {
        _logMsg("⚠️ Nenhuma promoção disponível para testar likes!");
        return;
      }

      final primeira = promocoes.first;
      final idPromocao = primeira.id;
      if (idPromocao == null) {
        _logMsg(
          "⚠️ A promoção selecionada não tem id (null). Abortando teste de like.",
        );
        return;
      }

      final idUsuario = userAuth.id;

      final curtiu = await _promoService.usuarioCurtiu(idPromocao, idUsuario);

      if (!curtiu) {
        await _promoService.darLike(idPromocao, idUsuario);
        _logMsg("👍 Like adicionado na promoção $idPromocao!");
      } else {
        await _promoService.removerLike(idPromocao, idUsuario);
        _logMsg("👎 Like removido da promoção $idPromocao!");
      }

      final total = await _promoService.contarLikes(idPromocao);
      _logMsg("💚 Total de likes na promoção: $total");
    } catch (e, st) {
      _logMsg("❌ Erro em _testLike: $e");
      _logMsg("$st");
    }
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
                  onPressed: _testLike,
                  child: const Text("Testar Like"),
                ),
                ElevatedButton(
                  onPressed: _limparLog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  child: const Text("Limpar Log"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _log,
                    style: const TextStyle(
                      fontFamily: "monospace",
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
