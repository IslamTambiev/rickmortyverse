import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rickmortyverse/models/character.dart';
import '../../../repositories/character_repository.dart';

part 'character_event.dart';
part 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository repository;
  int _currentPage = 1;
  bool _isFetching = false;
  bool _hasMore = true;

  CharacterBloc(this.repository) : super(CharacterInitial()) {
    on<CharacterEvent>((event, emit) {});
    on<FetchCharactersEvent>(_onFetchCharacters);
  }

  void _onFetchCharacters(
    FetchCharactersEvent event,
    Emitter<CharacterState> emit,
  ) async {
    if (_isFetching || !_hasMore) return;

    _isFetching = true;

    try {
      // Показ индикатора только при первом запуске
      if (state is CharacterInitial) {
        emit(CharacterLoading());
      }

      final newCharacters = await repository.fetchCharacters(_currentPage);

      _hasMore = newCharacters.length == repository.pageSize;
      _currentPage++;

      final existing =
          state is CharacterLoaded
              ? (state as CharacterLoaded).characters
              : <Character>[];

      emit(
        CharacterLoaded(
          characters: [...existing, ...newCharacters],
          hasMore: _hasMore,
        ),
      );
    } catch (e) {
      emit(CharacterError('Не удалось загрузить персонажей.'));
    } finally {
      _isFetching = false;
    }
  }
}
