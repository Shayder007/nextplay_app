class GameModel {
  // Dados da API de jogos
  final int id;
  final String nome;
  final String plataforma;
  final String genero;
  final double avaliacao;
  final String? descricao;
  final double preco;
  final String? imagemUrl;
  final String? desenvolvedor;
  final String? publicador;
  final DateTime? dataLancamento;
  final int totalAvaliacoes;

  GameModel({
    required this.id,
    required this.nome,
    required this.plataforma,
    required this.genero,
    required this.avaliacao,
    this.descricao,
    required this.preco,
    this.imagemUrl,
    this.desenvolvedor,
    this.publicador,
    this.dataLancamento,
    required this.totalAvaliacoes,
  });

  /// JSON vindo da API DE JOGOS
  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'],
      nome: json['nome'] ?? 'Sem Nome',
      plataforma: json['plataforma'] ?? 'Desconhecida',
      genero: json['genero'] ?? 'Sem Gênero',
      avaliacao: (json['avaliacao'] ?? 0.0).toDouble(),
      descricao: json['descricao'],
      preco: (json['preco'] ?? 0.0).toDouble(),
      imagemUrl: json['imagem_url'],
      desenvolvedor: json['desenvolvedor'],
      publicador: json['publicador'],
      dataLancamento: json['data_lancamento'] != null 
          ? DateTime.tryParse(json['data_lancamento']) 
          : null,
      totalAvaliacoes: json['total_avaliacoes'] ?? 0,
    );
  }
}
