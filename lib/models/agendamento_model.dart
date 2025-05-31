import 'package:promodeal/models/promocao_model.dart';

class AgendamentoModel{
  late final String id;
  late final PromocaoModel promocao;
  late final DateTime dataAgenda;

  AgendamentoModel(
      this.id,
      this.promocao,
      this.dataAgenda
      );
}
