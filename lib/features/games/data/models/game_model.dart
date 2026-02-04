class GameModel {
  // Dados da API de jogos
  final int id;
  final String nome;
  final String plataforma;
  final String genero;
  final double avaliacao;


  GameModel({
    required this.id,
    required this.nome,
    required this.plataforma,
    required this.genero,
    required this.avaliacao,
  });

  /// JSON vindo da API DE JOGOS
  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'],
      nome: json['nome'] ?? 'Sem Nome',
      plataforma: json['plataforma'] ?? 'Desconhecida',
      genero: json['genero'] ?? 'Sem Gênero',
      avaliacao: (json['avaliacao'] ?? 0.0).toDouble(),
    );
  }

}
