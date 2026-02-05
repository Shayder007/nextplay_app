import 'package:dio/dio.dart';
import '../models/game_model.dart';
import '../models/review_model.dart';
import '../models/comment_model.dart';
import '../models/genre_model.dart';
import 'game_repository.dart';
import '../../../../core/constants/api_constants.dart';

class GameRepositoryApi implements GameRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  @override
  Future<List<GameModel>> getGames({
    String? search,
    int? generoId,
    double? precoMin,
    double? precoMax,
  }) async {
    final response = await _dio.get(
      '/jogos',
      queryParameters: {
        if (search != null) 'busca': search,
        if (generoId != null) 'genero_id': generoId,
        if (precoMin != null) 'preco_min': precoMin,
        if (precoMax != null) 'preco_max': precoMax,
      },
    );

    return (response.data['jogos'] as List)
        .map((json) => GameModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<ReviewModel>> getReviews(int gameId) async {
    final response = await _dio.get('/jogos/$gameId/avaliacoes');
    return (response.data as List)
        .map((json) => ReviewModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<CommentModel>> getComments(int gameId) async {
    final response = await _dio.get('/jogos/$gameId/comentarios');
    return (response.data as List)
        .map((json) => CommentModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<GenreModel>> getGenres() async {
    final response = await _dio.get('/generos');
    return (response.data as List)
        .map((json) => GenreModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> addComment(int gameId, String nome, String texto) async {
    await _dio.post('/comentarios', data: {
      'jogo_id': gameId,
      'autor_nome': nome,
      'texto': texto,
    });
  }
}
