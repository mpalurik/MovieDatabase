import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/movie_model.dart';

class MovieService {
  final String apiUrl = "http://10.0.2.2:8000"; 

  Future<List<Movie>> getMovies() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/movies/'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Movie> getMovieById(String id) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/movies/$id'));

      if (response.statusCode == 200) {
        return Movie.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load movie');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/movies/name/search?query=$query'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Failed to search movies. Status code: ${response.statusCode}. Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Movie> createMovie(Movie movie) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/movies/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(movie.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Movie.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create movie');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Movie> updateMovie(String id, Movie movie) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/movies/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(movie.toJson()),
      );

      if (response.statusCode == 200) {
        return Movie.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update movie');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteMovie(String id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/movies/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete movie');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Movie>> getMoviesByDirector(String directorId) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/movies/director/$directorId'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Failed to load movies for director');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
