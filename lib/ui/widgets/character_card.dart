import 'package:flutter/material.dart';
import '../../models/character.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CharacterCard extends StatefulWidget {
  final Character character;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const CharacterCard({
    super.key,
    required this.character,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scale = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.6,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.6,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);

    _rotation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _handleToggle() {
    _controller.forward(from: 0);
    widget.onFavoriteToggle();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: widget.character.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          progressIndicatorBuilder:
              (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget:
              (context, url, error) =>
                  const Icon(Icons.broken_image, size: 50, color: Colors.grey),
        ),
        // leading: Image.network(
        //   widget.character.imageUrl,
        //   width: 50,
        //   height: 50,
        //   fit: BoxFit.cover,
        //   errorBuilder: (context, error, stackTrace) => const Icon(
        //     Icons.broken_image,
        //     size: 50,
        //     color: Colors.grey,
        //   ),
        // ),
        title: Text(widget.character.name),
        subtitle: Text(
          '${widget.character.status} • ${widget.character.species}',
        ),
        trailing: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotation.value * 3.14,
              child: Transform.scale(
                scale: _scale.value,
                child: IconButton(
                  icon:
                      widget.isFavorite
                          ? const Icon(Icons.star, color: Colors.yellow)
                          : const Icon(Icons.star_border),
                  onPressed: _handleToggle,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
