import 'package:hive/hive.dart';
part 'film.g.dart';

@HiveType(typeId: 0) // Pastikan ID ini belum dipakai adapter lain.
class Film {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String genres;

  @HiveField(3)
  final double rating;

  @HiveField(4)
  final String summary;

  @HiveField(5)
  final String image;

  Film({
    required this.id,
    required this.name,
    required this.genres,
    required this.rating,
    required this.summary,
    required this.image,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    final ratingData = json['rating'] as Map<String, dynamic>?;
    final imageData = json['image'] as Map<String, dynamic>?;
    final genresData = json['genres'] as List<dynamic>?;

    return Film(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Tanpa judul',
      genres: genresData?.join(', ') ?? '',
      rating: (ratingData?['average'] as num?)?.toDouble() ?? 0.0,
      summary: json['summary'] as String? ?? '',
      image: imageData?['medium'] as String? ?? '',
    );
  }
}
