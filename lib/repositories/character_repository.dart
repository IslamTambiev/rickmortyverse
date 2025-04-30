import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';
import '../../storage/local_storage.dart';

class CharacterRepository {
  final String _baseUrl = 'https://rickandmortyapi.com/api/character';
  final LocalStorage _localStorage = LocalStorage();
  final int pageSize = 20;

  /// Загружает персонажей по номеру страницы
  Future<List<Character>> fetchCharacters(int page) async {
    final cached = _localStorage.getCachedPage(page);

    if (cached.isNotEmpty) {
      return cached;
    }

    final url = Uri.parse('$_baseUrl?page=$page');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Ошибка загрузки персонажей (код: ${response.statusCode})');
    }

    final Map<String, dynamic> data = json.decode(response.body);
    if (!data.containsKey('results') || data['results'] is! List) {
      throw Exception('Некорректный формат ответа от сервера');
    }

    final List results = data['results'];

    final List<Character> characters = results
        .map((json) => Character.fromJson(json))
        .toList();

    _localStorage.cachePage(page, characters);
    return characters;
  }
}
