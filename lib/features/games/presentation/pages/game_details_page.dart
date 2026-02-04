import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/game_provider.dart';
import '../../data/models/game_model.dart';

class GameDetailsPage extends ConsumerWidget {
  final GameModel game;

  const GameDetailsPage({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(reviewsProvider(game.id));
    final commentsAsync = ref.watch(commentsProvider(game.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(game.nome),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game Info
            Text(
              game.nome,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text('Plataforma: ${game.plataforma}', style: Theme.of(context).textTheme.bodyLarge),
            Text('Gênero: ${game.genero}', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  game.avaliacao.toString(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            
            const Divider(height: 32),

            // Reviews Section
            Text(
              'Avaliações',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            reviewsAsync.when(
              data: (reviews) {
                if (reviews.isEmpty) return const Text('Nenhuma avaliação ainda.');
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: reviews.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text(review.nota.toString())),
                        title: Text(review.titulo ?? 'Sem título'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (review.texto != null && review.texto!.isNotEmpty)
                              Text(review.texto!),
                            const SizedBox(height: 4),
                            Text(
                              'Por: ${review.usuarioNome}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Erro ao carregar avaliações: $e'),
            ),

            const Divider(height: 32),

            // Comments Section
            Text(
              'Comentários',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            commentsAsync.when(
              data: (comments) {
                if (comments.isEmpty) return const Text('Nenhum comentário ainda.');
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: comments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Card(
                      child: ListTile(
                        title: Text(comment.texto),
                        subtitle: Text(
                          'Por: ${comment.usuarioNome}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Erro ao carregar comentários: $e'),
            ),
          ],
        ),
      ),
    );
  }
}
