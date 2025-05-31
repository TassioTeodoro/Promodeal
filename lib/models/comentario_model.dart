import 'package:promodeal/models/promocao_model.dart';
import 'package:promodeal/models/usuario_model.dart';

class ComentarioModel{
  late final String id;
  late final String conteudo;
  late final DateTime data;
  late final UsuarioModel usuario;
  late final PromocaoModel promocao;

  ComentarioModel(
      this.id,
      this.conteudo,
      this.data,
      this.usuario,
      this.promocao);
}