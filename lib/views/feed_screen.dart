import 'package:flutter/material.dart';
import 'package:promodeal/widget/post_card.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  AppUser? _usuario;
  int _currentIndex = 1; // por padrão começa no Feed

  final _userService = UserService();

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

  @override
  Widget build(BuildContext context) {
    if (_usuario == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isComerciante = _usuario!.isComerciante;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          PostCard(
            loja: "Lojas XYZ",
            data: "10/05/2025 07:00",
            local: "Place-State",
            descricao:
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi.",
            precoDe: 100,
            precoPor: 60,
            tags: const ["Tag1", "Tag2", "Tag3"],
          ),
          const SizedBox(height: 12),
          PostCard(
            loja: "Lojas XYZ",
            data: "10/05/2025 07:00",
            local: "Place-State",
            descricao:
                "Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla.",
            precoDe: 200,
            precoPor: 150,
            tags: const ["Tag1", "Tag2"],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() => _currentIndex = index);
          // TODO: navegar entre telas reais
        },
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
