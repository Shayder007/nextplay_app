class ReviewModel {
  final int id;
  final double nota;
  final String? titulo;
  final String? texto;
  final String usuarioNome;

  ReviewModel({
    required this.id,
    required this.nota,
    this.titulo,
    this.texto,
    required this.usuarioNome,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      nota: (json['nota'] ?? 0.0).toDouble(),
      titulo: json['titulo'],
      texto: json['texto'],
      usuarioNome: json['usuario']?['nome'] ?? 'Anônimo',
    );
  }
}
