import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickmortyverse/blocs/theme/theme_cubit.dart';
import '../../storage/local_storage.dart';
import '../../models/character.dart';
import '../widgets/character_card.dart';

enum SortOption { nameAsc, nameDesc, statusAsc, statusDesc }

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final LocalStorage _localStorage = LocalStorage();
  SortOption _sortOption = SortOption.nameAsc;

  List<Character> get _favorites {
    final favorites = _localStorage.getFavorites();

    switch (_sortOption) {
      case SortOption.nameAsc:
        favorites.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.nameDesc:
        favorites.sort((a, b) => b.name.compareTo(a.name));
        break;
      case SortOption.statusAsc:
        favorites.sort((a, b) => a.status.compareTo(b.status));
        break;
      case SortOption.statusDesc:
        favorites.sort((a, b) => b.status.compareTo(a.status));
        break;
    }

    return favorites;
  }

  void _onSortSelected(SortOption option) {
    setState(() {
      _sortOption = option;
    });
  }

  String get _sortLabel {
    switch (_sortOption) {
      case SortOption.nameAsc:
        return 'Имя ↑';
      case SortOption.nameDesc:
        return 'Имя ↓';
      case SortOption.statusAsc:
        return 'Статус ↑';
      case SortOption.statusDesc:
        return 'Статус ↓';
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorites = _favorites;
    final themeCubit = context.read<ThemeCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранные'),
        actions: [
          PopupMenuButton<SortOption>(
            tooltip: 'Сортировка',
            onSelected: _onSortSelected,
            icon: Row(
              children: [
                const Icon(Icons.sort),
                const SizedBox(width: 4),
                Text(_sortLabel, style: const TextStyle(fontSize: 14)),
              ],
            ),
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: SortOption.nameAsc,
                    child: Text('Имя ↑ (А–Я)'),
                  ),
                  const PopupMenuItem(
                    value: SortOption.nameDesc,
                    child: Text('Имя ↓ (Я–А)'),
                  ),
                  const PopupMenuItem(
                    value: SortOption.statusAsc,
                    child: Text('Статус ↑'),
                  ),
                  const PopupMenuItem(
                    value: SortOption.statusDesc,
                    child: Text('Статус ↓'),
                  ),
                ],
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: themeCubit.toggleTheme,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body:
          favorites.isEmpty
              ? const Center(child: Text('Список избранных пуст.'))
              : ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final character = favorites[index];
                  return CharacterCard(
                    character: character,
                    isFavorite: true,
                    onFavoriteToggle: () {
                      setState(() {
                        _localStorage.removeFavorite(character.id);
                      });
                    },
                  );
                },
              ),
    );
  }
}
