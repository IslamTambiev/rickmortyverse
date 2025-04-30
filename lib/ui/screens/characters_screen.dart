import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickmortyverse/blocs/theme/theme_cubit.dart';
import '../../blocs/character_bloc/character_bloc.dart';
import '../../storage/local_storage.dart';
import '../widgets/character_card.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  final ScrollController _scrollController = ScrollController();
  final LocalStorage _localStorage = LocalStorage();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      context.read<CharacterBloc>().add(FetchCharactersEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Персонажи'),actions: [
        IconButton(
          icon: Icon(
            Theme.of(context).brightness == Brightness.dark
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          onPressed: themeCubit.toggleTheme,
        ),
        const SizedBox(width: 12),
      ],),
      body: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          if (state is CharacterLoading && state is! CharacterLoaded) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CharacterLoaded) {
            final characters = state.characters;

            return ListView.builder(
              controller: _scrollController,
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];
                final isFavorite = _localStorage.isFavorite(character.id);

                return CharacterCard(
                  character: character,
                  isFavorite: isFavorite,
                  onFavoriteToggle: () {
                    setState(() {
                      if (isFavorite) {
                        _localStorage.removeFavorite(character.id);
                      } else {
                        _localStorage.addFavorite(character);
                      }
                    });
                  },
                );
              },
            );
          } else if (state is CharacterError) {
            return const Center(child: Text('Ошибка загрузки персонажей.'));
          } else {
            return const Center(child: Text('Нет данных.'));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
