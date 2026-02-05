import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nextplay/features/games/data/models/game_model.dart';
import 'package:nextplay/features/games/data/models/review_model.dart';
import 'package:nextplay/features/games/data/models/comment_model.dart';
import 'package:nextplay/features/games/data/models/genre_model.dart';

import 'package:nextplay/features/games/data/repositories/game_repository.dart';
import 'package:nextplay/features/games/data/repositories/game_repository_api.dart';

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  return GameRepositoryApi();
});

final gamesProvider = FutureProvider<List<GameModel>>((ref) async {
  final repository = ref.watch(gameRepositoryProvider);
  return repository.getGames();
});

// Gêneros
final genresProvider = FutureProvider<List<GenreModel>>((ref) async {
  final repository = ref.watch(gameRepositoryProvider);
  return repository.getGenres();
});

// Filtros
class GameFilters {
  final String? search;
  final int? generoId;
  final double? precoMin;
  final double? precoMax;

  GameFilters({
    this.search,
    this.generoId,
    this.precoMin,
    this.precoMax,
  });

  GameFilters copyWith({
    String? search,
    int? generoId,
    double? precoMin,
    double? precoMax,
    bool clearSearch = false,
    bool clearGenero = false,
  }) {
    return GameFilters(
      search: clearSearch ? null : (search ?? this.search),
      generoId: clearGenero ? null : (generoId ?? this.generoId),
      precoMin: precoMin ?? this.precoMin,
      precoMax: precoMax ?? this.precoMax,
    );
  }
}

final gameFiltersProvider = StateProvider<GameFilters>((ref) => GameFilters());

final filteredGamesProvider = FutureProvider<List<GameModel>>((ref) async {
  final filters = ref.watch(gameFiltersProvider);
  final repository = ref.watch(gameRepositoryProvider);
  return repository.getGames(
    search: filters.search,
    generoId: filters.generoId,
    precoMin: filters.precoMin,
    precoMax: filters.precoMax,
  );
});

final reviewsProvider = FutureProvider.family<List<ReviewModel>, int>((ref, gameId) async {
  final repository = ref.watch(gameRepositoryProvider);
  return repository.getReviews(gameId);
});

final commentsProvider = FutureProvider.family<List<CommentModel>, int>((ref, gameId) async {
  final repository = ref.watch(gameRepositoryProvider);
  return repository.getComments(gameId);
});

