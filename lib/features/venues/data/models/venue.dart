class Venue {
  final String id;
  final String url;
  final String name;
  final String description;
  bool isFavorite;

  Venue({
    required this.id,
    required this.url,
    required this.name,
    required this.description,
    this.isFavorite = false,
  });
}