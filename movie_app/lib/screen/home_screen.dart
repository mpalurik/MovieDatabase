import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/screen/create_movie_form.dart';
import 'package:movie_app/screen/detail_screen.dart';
import 'package:movie_app/services/movie_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieService movieService = MovieService();
  TextEditingController searchController = TextEditingController();
  late Future<List<Movie>> movieList;

  @override
  void initState() {
    super.initState();
    movieList = movieService.getMovies();
  }

  void refreshMovies() {
    setState(() {
      movieList = movieService.getMovies();
    });
  }

  void searchMovies() {
    setState(() {
      movieList = movieService.searchMovies(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateMovieFormPage()),
              );
              refreshMovies();
        },
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.primary,
          size: 36,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8,12,8,6 ),
            child: TextField(
              controller: searchController,
              autofocus: false,
              decoration: InputDecoration(
                labelText: 'Search a movie',
                labelStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Icons.search,color: Colors.red),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.red),
                  onPressed: () {
                    searchController.clear(); // Clears the text field
                    searchMovies(); // Optionally, trigger the search update
                  },
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusColor: Theme.of(context).primaryColor,
                floatingLabelStyle: const TextStyle(color: Colors.white,),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(8)
                ),
              ),
              style: const TextStyle(color: Colors.white),
                cursorColor: Colors.red,
              onChanged: (query) {
                searchMovies();
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: movieList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No movies found.'));
                } else {
                  final movies = snapshot.data!;
                  return ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                        child: GestureDetector(
                          onTap: () async {
                            searchController.clear();
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(movie: movie),
                              ),
                            );
                            
                            refreshMovies();
                          },
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                              ),
                              child: Column(
                                children: [
                                  Hero(
                                    tag: movie.id!,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: movie.imageUrl,
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            movie.title,
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                            maxLines: 2,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6,),
                                        Text(
                                          '${movie.releaseYear}',
                                          style: const TextStyle(fontSize: 16,color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}