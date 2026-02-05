class GenreModel {
  final int id;
  final String nome;
  final String? descricao;

  GenreModel({
    required this.id,
    required this.nome,
    this.descricao,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
    );
  }
}
