import 'package:flutter/material.dart';
import 'package:promodeal/models/user_model.dart';
import 'package:promodeal/services/promocao_service.dart';
import 'package:promodeal/services/user_service.dart';
import 'package:promodeal/views/subviews/account_screen.dart';
import 'package:promodeal/views/subviews/post_screen.dart';
import 'package:promodeal/widget/post_card.dart';

import 'package:supabase_flutter/supabase_flutter.dart';


class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  AppUser? _usuario;
  int _currentIndex = 1;
  final _userService = UserService();
  final _promoService = PromocaoService();

  List<Map<String, dynamic>> _promocoes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final supabase = Supabase.instance.client;
    final userAuth = supabase.auth.currentUser;

    if (userAuth != null) {
      final usuario = await _userService.buscarUsuarioPorId(userAuth.id);
      final promocoes = await _promoService.listarPromocoesComUsuarios();

      setState(() {
        _usuario = usuario;
        _promocoes = promocoes;
        _isLoading = false;
      });
    }
  }

  void _onNavTapped(int index) {

    if(index == 0){
       Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProfileScreen(idUsuario: _usuario!.id)),
      ).then((_) => _carregarDados());
    }else if (_usuario?.isComerciante == true && index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PublishPromotionScreen()),
      ).then((_) => _carregarDados());
    } else {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_usuario == null) {
      return const Scaffold(
        body: Center(child: Text("Usuário não autenticado")),
      );
    }

    final isComerciante = _usuario!.isComerciante;

    return Scaffold(
      appBar: AppBar(title: const Text("Promoções")),
      body: RefreshIndicator(
        onRefresh: _carregarDados,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: _promocoes.length,
          itemBuilder: (context, index) {
            final promo = _promocoes[index];
            final user = promo['usuarios'] ?? {};

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PostCard(
                idUsuario: user["id"],
                idPromocao: promo['id'],
                loja: user['nome'] ?? "Loja",
                data: promo['data_publicacao'] ?? "Data não definida",
                local: user['endereco'] ?? "Local não informado",
                descricao: promo['descricao'] ?? "",
                precoDe: (promo['preco_de'] as num).toDouble(),
                precoPor: (promo['preco_por'] as num).toDouble(),
                tags: (promo['tags'] as List<dynamic>)
                    .map((t) => t.toString())
                    .toList(),
                fotoPerfilUrl: null, // TODO: integrar com avatar
                fotoDaPromo: promo["imagem_url"],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        onTap: _onNavTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Conta",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: "Feed",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Busca",
          ),
          if (isComerciante)
            const BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              label: "Postar",
            ),
        ],
      ),
    );
  }
}
