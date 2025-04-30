part of 'character_bloc.dart';

@immutable
sealed class CharacterState {}

/// Начальное состояние
final class CharacterInitial extends CharacterState {}

/// Состояние загрузки данных (например, при первом запуске или пагинации)
final class CharacterLoading extends CharacterState {}

/// Состояние с успешно загруженными персонажами
final class CharacterLoaded extends CharacterState {
  final List<Character> characters;
  final bool hasMore;

  CharacterLoaded({required this.characters, required this.hasMore});
}

/// Состояние ошибки при загрузке данных
final class CharacterError extends CharacterState {
  final String message;

  CharacterError(this.message);
}
