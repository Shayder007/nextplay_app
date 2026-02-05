import '../models/game_model.dart';
import '../models/review_model.dart';
import '../models/comment_model.dart';

abstract class GameRepository {
  Future<List<GameModel>> getGames();
  Future<List<ReviewModel>> getReviews(int gameId);
  Future<List<CommentModel>> getComments(int gameId);
  Future<void> addComment(int gameId, String nome, String texto);
}