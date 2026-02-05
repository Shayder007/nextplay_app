import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/game_provider.dart';
import 'game_details_page.dart';

class SearchGamesPage extends ConsumerStatefulWidget {
  const SearchGamesPage({super.key});

  @override
  ConsumerState<SearchGamesPage> createState() => _SearchGamesPageState();
}

class _SearchGamesPageState extends ConsumerState<SearchGamesPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(gameFiltersProvider);
    final gamesAsync = ref.watch(filteredGamesProvider);
    final genresAsync = ref.watch(genresProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Jogos'),
      ),
      body: Column(
        children: [
          // Barra de Busca
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Nome do jogo...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(gameFiltersProvider.notifier).update(
                                (state) => state.copyWith(clearSearch: true),
                              );
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
              onChanged: (value) {
                ref.read(gameFiltersProvider.notifier).update(
                      (state) => state.copyWith(search: value),
                    );
              },
            ),
          ),

          // Filtros de Gênero
          SizedBox(
            height: 50,
            child: genresAsync.when(
              data: (genres) => ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: genres.length,
                itemBuilder: (context, index) {
                  final genre = genres[index];
                  final isSelected = filters.generoId == genre.id;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      label: Text(genre.nome),
                      selected: isSelected,
                      onSelected: (selected) {
                        ref.read(gameFiltersProvider.notifier).update(
                              (state) => state.copyWith(
                                generoId: selected ? genre.id : null,
                                clearGenero: !selected,
                              ),
                            );
                      },
                      selectedColor: Theme.of(context).colorScheme.primaryContainer,
                      checkmarkColor: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),

          // Sliders de Preço (Opcional, mas legal)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
            child: Row(
              children: [
                const Text('Preço até: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: Slider(
                    value: filters.precoMax ?? 500.0,
                    min: 0,
                    max: 500,
                    divisions: 10,
                    label: filters.precoMax == null ? 'Qualquer' : 'R\$ ${filters.precoMax!.toInt()}',
                    onChanged: (value) {
                      ref.read(gameFiltersProvider.notifier).update(
                            (state) => state.copyWith(precoMax: value),
                          );
                    },
                  ),
                ),
                Text(filters.precoMax == null ? 'Máx' : 'R\$${filters.precoMax!.toInt()}'),
              ],
            ),
          ),

          const Divider(),

          // Resultados
          Expanded(
            child: gamesAsync.when(
              data: (games) {
                if (games.isEmpty) {
                  return const Center(child: Text('Nenhum jogo encontrado.'));
                }
                return ListView.builder(
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    final game = games[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: ListTile(
                        leading: game.imagemUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  game.imagemUrl!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.gamepad),
                                ),
                              )
                            : const Icon(Icons.gamepad),
                        title: Text(game.nome),
                        subtitle: Text(game.genero),
                        trailing: Text(
                          game.preco == 0 ? 'Grátis' : 'R\$ ${game.preco.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GameDetailsPage(game: game),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Erro: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
