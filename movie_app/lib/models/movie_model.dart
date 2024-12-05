class Movie {
  String? id;
  String title;
  int releaseYear;
  List<String> genre;
  String imageUrl;
  String description;
  String directorId;

  Movie({
    this.id,
    required this.title,
    required this.releaseYear,
    required this.genre,
    required this.imageUrl,
    required this.description,
    required this.directorId,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      releaseYear: json['releaseYear'],
      genre: List<String>.from(json['genre']),
      imageUrl: json['imageUrl'],
      description: json['description'],
      directorId: json['director'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'releaseYear': releaseYear,
      'genre': genre,
      'imageUrl': imageUrl,
      'description': description,
      'director': directorId,
    };
  }
}