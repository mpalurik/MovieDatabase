import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/director_model.dart';

class DirectorService {
  final String apiUrl = "http://10.0.2.2:8000";

  Future<List<Director>> getDirectors() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/directors/'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((director) => Director.fromJson(director)).toList();
      } else {
        throw Exception('Failed to load directors');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Director> getDirectorById(String id) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/directors/$id'));

      if (response.statusCode == 200) {
        return Director.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load director');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Director>> createDirectors(List<Director> directors) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/directors/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(directors.map((director) => director.toJson()).toList()),
      );

      if (response.statusCode == 200) {
        // Deserializujte odpověď a vraťte seznam vytvořených režisérů
        List<dynamic> responseBody = json.decode(response.body);
        return responseBody.map((director) => Director.fromJson(director)).toList();
      } else {
        throw Exception('Failed to create directors');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Director> updateDirector(String id, Director director) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/directors/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(director.toJson()),
      );

      if (response.statusCode == 200) {
        return Director.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update director');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteMultipleDirectors(List<String> ids) async {
  try {
    final response = await http.delete(
      Uri.parse('$apiUrl/directors/bulk'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ids), // Posíláme seznam ID režisérů
    );

    if (response.statusCode == 200) {
      // ignore: avoid_print
      print('Directors deleted successfully');
    } else {
      throw Exception('Failed to delete directors');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}
}
