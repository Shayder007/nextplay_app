import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/game_provider.dart';
import '../../data/models/game_model.dart';

class GameDetailsPage extends ConsumerStatefulWidget {
  final GameModel game;

  const GameDetailsPage({
    super.key,
    required this.game,
  });

  @override
  ConsumerState<GameDetailsPage> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends ConsumerState<GameDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final repository = ref.read(gameRepositoryProvider);
      await repository.addComment(
        widget.game.id,
        _nameController.text,
        _commentController.text,
      );

      // Refresh comments and clear form
      ref.invalidate(commentsProvider(widget.game.id));
      _commentController.clear();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comentário enviado com sucesso!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao enviar comentário: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reviewsAsync = ref.watch(reviewsProvider(widget.game.id));
    final commentsAsync = ref.watch(commentsProvider(widget.game.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.nome),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game Image
            if (widget.game.imagemUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.game.imagemUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(Icons.gamepad, size: 50),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            
            // Basic Info & Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.game.nome,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Text(
                  widget.game.preco == 0 ? 'Grátis' : 'R\$ ${widget.game.preco.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Platform & Genre
            Row(
              children: [
                Chip(label: Text(widget.game.plataforma)),
                const SizedBox(width: 8),
                Expanded(child: Text(widget.game.genero, style: Theme.of(context).textTheme.bodyMedium)),
              ],
            ),
            const SizedBox(height: 16),

            // Rating & Total Reviews
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  widget.game.avaliacao.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: 8),
                Text('(${widget.game.totalAvaliacoes} avaliações)', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            if (widget.game.descricao != null) ...[
              Text('Descrição', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(widget.game.descricao!),
              const SizedBox(height: 16),
            ],

            // Developer & Publisher
            if (widget.game.desenvolvedor != null || widget.game.publicador != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      if (widget.game.desenvolvedor != null)
                        _buildInfoRow('Desenvolvedor', widget.game.desenvolvedor!),
                      if (widget.game.publicador != null)
                        _buildInfoRow('Publicador', widget.game.publicador!),
                      if (widget.game.dataLancamento != null)
                        _buildInfoRow('Lançamento', '${widget.game.dataLancamento!.day}/${widget.game.dataLancamento!.month}/${widget.game.dataLancamento!.year}'),
                    ],
                  ),
                ),
              ),
            ],
            
            const Divider(height: 48),

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
                          'Por: ${comment.displayName}',
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

            const Divider(height: 32),

            // Add Comment Form
            Text(
              'Adicionar Comentário',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Seu Nome',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu nome';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      labelText: 'Comentário',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um comentário';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitComment,
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Enviar Comentário'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
