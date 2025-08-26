import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../routes.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _userService = UserService();
  final _auth = AuthService();
  AppUser? _user;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final u = await _userService.getCurrentUser();
    if (mounted) setState(() => _user = u);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conta')),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(_user!.nome),
                    subtitle: Text(_user!.email),
                  ),
                  const SizedBox(height: 12),
                  if (_user!.isComerciante) ...[
                    const Text(
                      'Comerciante',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('CNPJ: ${_user!.cnpj ?? '-'}'),
                    Text('Endereço: ${_user!.endereco ?? '-'}'),
                    const SizedBox(height: 12),
                  ],
                  FilledButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, Routes.accountSettings),
                    child: const Text('Editar conta'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () async {
                      await _auth.signOut();
                      if (mounted)
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.login,
                          (_) => false,
                        );
                    },
                    child: const Text('Sair'),
                  ),
                ],
              ),
            ),
    );
  }
}
