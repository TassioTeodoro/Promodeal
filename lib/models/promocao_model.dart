class PromocaoModel{
  late final String id;
  late final String titulo;
  late final String descricao;
  late final double precoOrig;
  late final double precoDisc;
  late final DateTime dataInicio;
  late final DateTime dataFim;
  late final String categoria;

  PromocaoModel(
      this.id,
      this.titulo,
      this.descricao,
      this.precoOrig,
      this.precoDisc,
      this.dataInicio,
      this.dataFim,
      this.categoria,
      );
}