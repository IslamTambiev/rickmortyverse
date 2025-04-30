import 'package:hive/hive.dart';
import '../models/character.dart';

class LocalStorage {
  static const String _favoritesBoxName = 'favorites';
  static const String _charactersBox = 'characters_by_page';

  Future<void> init() async {
    await Hive.openBox<Character>(_favoritesBoxName);
    await Hive.openBox<List>(_charactersBox);
  }

  Box<Character> get favoritesBox => Hive.box<Character>(_favoritesBoxName);

  List<Character> getFavorites() {
    return favoritesBox.values.toList();
  }

  void addFavorite(Character character) {
    favoritesBox.put(character.id, character);
  }

  void removeFavorite(int id) {
    favoritesBox.delete(id);
  }

  bool isFavorite(int id) {
    return favoritesBox.containsKey(id);
  }

  // Кэш
  void cachePage(int page, List<Character> characters) {
    final box = Hive.box<List>(_charactersBox);
    box.put(page, characters.map((c) => c.toJson()).toList());
  }

  List<Character> getCachedPage(int page) {
    final box = Hive.box<List>(_charactersBox);
    final raw = box.get(page);

    if (raw == null) return [];

    return (raw as List)
        .map((item) => Character.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
