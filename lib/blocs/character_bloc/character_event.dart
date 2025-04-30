part of 'character_bloc.dart';

@immutable
sealed class CharacterEvent {}

class FetchCharactersEvent extends CharacterEvent {}