class CommentModel {
  final int id;
  final String texto;
  final String usuarioNome;
  final String? autorNome;

  CommentModel({
    required this.id,
    required this.texto,
    required this.usuarioNome,
    this.autorNome,
  });

  String get displayName => (autorNome != null && autorNome!.isNotEmpty) ? autorNome! : usuarioNome;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      texto: json['texto'] ?? '',
      usuarioNome: json['usuario']?['nome'] ?? 'Anônimo',
      autorNome: json['autor_nome'],
    );
  }
}
