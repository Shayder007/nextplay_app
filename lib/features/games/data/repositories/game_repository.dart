import '../models/game_model.dart';
import '../models/review_model.dart';
import '../models/comment_model.dart';
import '../models/genre_model.dart';

abstract class GameRepository {
  Future<List<GameModel>> getGames({
    String? search,
    int? generoId,
    double? precoMin,
    double? precoMax,
  });
  Future<List<ReviewModel>> getReviews(int gameId);
  Future<List<CommentModel>> getComments(int gameId);
  Future<List<GenreModel>> getGenres();
  Future<void> addComment(int gameId, String nome, String texto);
}