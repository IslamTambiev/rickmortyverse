import 'package:hive/hive.dart';

part 'character.g.dart';

@HiveType(typeId: 0)
class Character {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final String species;

  @HiveField(4)
  final String imageUrl;

  @HiveField(5)
  final String type;

  @HiveField(6)
  final String gender;

  @HiveField(7)
  final String origin;

  @HiveField(8)
  final String location;

  @HiveField(9)
  final List<String> episodes;

  @HiveField(10)
  final String url;

  @HiveField(11)
  final DateTime created;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.imageUrl,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.episodes,
    required this.url,
    required this.created,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      imageUrl: json['image'],
      type: json['type'] ?? '',
      gender: json['gender'],
      origin: json['origin']['name'],
      location: json['location']['name'],
      episodes: List<String>.from(json['episode']),
      url: json['url'],
      created: DateTime.parse(json['created']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'image': imageUrl,
      'type': type,
      'gender': gender,
      'origin': {'name': origin},
      'location': {'name': location},
      'episode': episodes,
      'url': url,
      'created': created.toIso8601String(),
    };
  }
}
