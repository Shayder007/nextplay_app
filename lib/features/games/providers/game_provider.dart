import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nextplay/features/games/data/models/game_model.dart';
import 'package:nextplay/features/games/data/models/review_model.dart';
import 'package:nextplay/features/games/data/models/comment_model.dart';

import 'package:nextplay/features/games/data/repositories/game_repository.dart';
import 'package:nextplay/features/games/data/repositories/game_repository_api.dart';



final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepositoryApi();
});

final gamesProvider = FutureProvider<List<GameModel>>((ref) async {
  final repository = ref.watch(gameRepositoryProvider);
  return repository.getGames();
});

final reviewsProvider = FutureProvider.family<List<ReviewModel>, int>((ref, gameId) async {
  final repository = ref.watch(gameRepositoryProvider);
  return repository.getReviews(gameId);
});

final commentsProvider = FutureProvider.family<List<CommentModel>, int>((ref, gameId) async {
  final repository = ref.watch(gameRepositoryProvider);
  return repository.getComments(gameId);
});

