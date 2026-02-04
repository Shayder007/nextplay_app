class CommentModel {
  final int id;
  final String texto;
  final String usuarioNome;

  CommentModel({
    required this.id,
    required this.texto,
    required this.usuarioNome,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      texto: json['texto'] ?? '',
      usuarioNome: json['usuario']?['nome'] ?? 'Anônimo',
    );
  }
}
