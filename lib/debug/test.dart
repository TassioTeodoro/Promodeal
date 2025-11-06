import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  final _userService = UserService();
  final _promoService = PromocaoService();
  final _comentarioService = ComentarioService();
  final _supabase = Supabase.instance.client;

  String _log = "";

  void _logMsg(String msg) {
    setState(() => _log += "$msg\n");
  }

  void _limparLog() => setState(() => _log = "");

  // IDs fixos para os testes
  static const String userId = "usuario_teste_123";
  static const String promoId = "promo_teste_123";
  static const String commentId = "coment_teste_123";

  // ==========================================================
  // 🔹 TESTE DE CRUD DE USUÁRIOS
  // ==========================================================
  Future<void> _testUsuario() async {
    try {
      _logMsg("🔹 Iniciando teste de usuário...");
      final user = AppUser(
        id: userId,
        nome: "Usuário de Teste",
        email: "teste@teste.com",
        isComerciante: true,
        cnpj: "12345678000199",
        endereco: "Rua Teste, 123",
        bio: "Usuário criado automaticamente para testes",
      );

      await _userService.criarUsuario(user);
      _logMsg("✅ Usuário criado.");

      final lista = await _userService.listarUsuarios();
      _logMsg("📋 Total de usuários: ${lista.length}");

      final atualizado = AppUser(
        id: userId,
        nome: "Usuário Atualizado",
        email: "teste@teste.com",
        isComerciante: true,
        cnpj: "12345678000199",
        endereco: "Rua Atualizada, 456",
        bio: "Atualizado durante o teste",
      );

      await _userService.atualizarUsuario(atualizado);
      _logMsg("♻️ Usuário atualizado.");

      await _userService.deletarUsuario(userId);
      _logMsg("🗑️ Usuário removido com sucesso.");
    } catch (e) {
      _logMsg("❌ Erro em _testUsuario: $e");
    }
  }

  // ==========================================================
  // 🔹 TESTE DE CRUD DE PROMOÇÕES
  // ==========================================================
  Future<void> _testPromocao() async {
    try {
      _logMsg("🔹 Iniciando teste de promoção...");

      // Criar usuário temporário para vincular promoção
      await _supabase.from('usuarios').upsert({
        'id': userId,
        'nome': 'Comerciante Teste',
        'email': 'teste@teste.com',
        'is_comerciante': true,
      });

      final promocao = Promocao(
        id: promoId,
        idUsuario: userId,
        descricao: "Promoção de Teste",
        precoDe: 100,
        precoPor: 79.9,
        tags: ["teste", "promo"],
        dataPublicacao: DateTime.now(),
        imagemUrl: null,
      );

      await _promoService.criarPromocao(promocao);
      _logMsg("✅ Promoção criada.");

      final promocoes = await _promoService.listarPromocoes();
      _logMsg("📋 Promoções totais: ${promocoes.length}");

      final atualizada = Promocao(
        id: promoId,
        idUsuario: userId,
        descricao: "Promoção Atualizada",
        precoDe: 120,
        precoPor: 99.9,
        tags: ["atualizada"],
        dataPublicacao: DateTime.now(),
        imagemUrl: null,
      );

      await _promoService.atualizarPromocao(atualizada);
      _logMsg("♻️ Promoção atualizada.");

      await _promoService.deletarPromocao(promoId);
      _logMsg("🗑️ Promoção deletada com sucesso.");

      await _supabase.from('usuarios').delete().eq('id', userId);
    } catch (e) {
      _logMsg("❌ Erro em _testPromocao: $e");
    }
  }

  // ==========================================================
  // 🔹 TESTE DE CRUD DE COMENTÁRIOS
  // ==========================================================
  Future<void> _testComentario() async {
    try {
      _logMsg("🔹 Iniciando teste de comentário...");

      // Usuário e promoção de teste
      await _supabase.from('usuarios').upsert({
        'id': userId,
        'nome': 'Usuário Comentador',
        'email': 'coment@teste.com',
        'is_comerciante': false,
      });

      await _supabase.from('promocoes').upsert({
        'id': promoId,
        'id_usuario': userId,
        'descricao': 'Promoção Comentada',
        'preco_de': 50,
        'preco_por': 35,
        'tags': ['coment'],
        'data_publicacao': DateTime.now().toIso8601String(),
      });

      final comentario = Comentario(
        id: commentId,
        idUsuario: userId,
        idPromocao: promoId,
        conteudo: "Comentário de teste automático",
      );

      await _comentarioService.criarComentario(comentario);
      _logMsg("✅ Comentário criado.");

      final lista = await _comentarioService.listarComentariosPorPromocao(promoId);
      _logMsg("📋 Comentários encontrados: ${lista.length}");

      await _comentarioService.deletarComentario(commentId);
      _logMsg("🗑️ Comentário removido.");

      await _promoService.deletarPromocao(promoId);
      await _userService.deletarUsuario(userId);
    } catch (e) {
      _logMsg("❌ Erro em _testComentario: $e");
    }
  }

  // ==========================================================
  // 🔹 TESTE DE LIKES (sem autenticação)
  // ==========================================================
  Future<void> _testLikes() async {
    try {
      _logMsg("🔹 Testando likes...");
      await _supabase.from('usuarios').upsert({
        'id': userId,
        'nome': 'Usuário Like',
        'email': 'like@teste.com',
        'is_comerciante': false,
      });

      await _supabase.from('promocoes').upsert({
        'id': promoId,
        'id_usuario': userId,
        'descricao': 'Promoção Curtida',
        'preco_de': 70,
        'preco_por': 49.9,
        'tags': ['like'],
        'data_publicacao': DateTime.now().toIso8601String(),
      });

      // Inserir like
      await _supabase.from('likes').insert({
        'id_promocao': promoId,
        'id_usuario': userId,
      });
      _logMsg("👍 Like inserido.");

      // Contar likes
      final count = await _promoService.contarLikes(promoId);
      _logMsg("💚 Total de likes: $count");

      // Remover like
      await _supabase
          .from('likes')
          .delete()
          .eq('id_promocao', promoId)
          .eq('id_usuario', userId);
      _logMsg("👎 Like removido.");

      // Limpeza
      await _promoService.deletarPromocao(promoId);
      await _userService.deletarUsuario(userId);
    } catch (e) {
      _logMsg("❌ Erro em _testLikes: $e");
    }
  }

  // ==========================================================
  // 🔹 INTERFACE VISUAL DE TESTES
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🧪 Testes CRUD – Promodeal")),
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
                    child: const Text("Testar Usuário")),
                ElevatedButton(
                    onPressed: _testPromocao,
                    child: const Text("Testar Promoção")),
                ElevatedButton(
                    onPressed: _testComentario,
                    child: const Text("Testar Comentário")),
                ElevatedButton(
                    onPressed: _testLikes,
                    child: const Text("Testar Likes")),
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
