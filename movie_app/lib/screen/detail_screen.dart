import 'package:cached_network_image/cached_network_image.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:movie_app/models/director_model.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/screen/create_director_form.dart';
import 'package:movie_app/screen/delete_directors.dart';
import 'package:movie_app/services/director_service.dart';
import 'package:movie_app/services/movie_service.dart';
import 'package:movie_app/widgets/edit_movie_dialog.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  const DetailScreen({required this.movie, super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Movie movie;

  final ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  late Future<Director> directorFuture;
  final DirectorService _directorService = DirectorService();
  late Future<List<Movie>> directorMovies;

  @override
  void initState() {
    super.initState();
    movie = widget.movie;
    directorFuture = _directorService.getDirectorById(movie.directorId);
    directorMovies = MovieService().getMoviesByDirector(movie.directorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Detail",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        openCloseDial: isDialOpen,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.delete),
            label: "Delete",
            backgroundColor: Colors.red.shade900,
            onTap: () {
              _showDeleteConfirmationDialog(context);
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.edit),
            label: "Edit",
            backgroundColor: Colors.blue.shade300,
            onTap: () {
              void openEditDialog() {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return EditMovieDialog(
                      movie: movie, 
                      onSave: (updatedMovie) {
                        MovieService movieService = MovieService();
                        movieService.updateMovie(movie.id!, updatedMovie);

                        setState(() {
                          movie = updatedMovie;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Movie updated successfully')));
                      },
                    );
                  },
                );
              }

              openEditDialog();
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.add),
            label: "Create a new director",
            backgroundColor: Colors.green.shade800,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateDirectorFormPage(),
                ),
              );
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: FutureBuilder<Director>(
        future: directorFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _buildMovieCardWithNoDirector();
          } else if (!snapshot.hasData) {
            return _buildMovieCardWithNoDirector();
          } else {
            Director director = snapshot.data!;
            String formattedDate =
                '${director.bornDate.day}.${director.bornDate.month}.${director.bornDate.year}';

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 100),
              child: Column(
                children: [
                  _buildMovieCard(director),
                  _buildDirectorCard(director, formattedDate),
                  const SizedBox(height: 8,),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DeleteDirectorsPage()), // Přejít na DirectorsPage
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      padding: const EdgeInsets.all(16),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                            ),
                          Text(
                            'Delete Directors',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  )

                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildMovieCardWithNoDirector() {
  return SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 100),
    child: Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: CachedNetworkImage(
                        imageUrl: movie.imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Text(
                      movie.title, 
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Release year: ${movie.releaseYear}',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text(
                          "Genres: ",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        const SizedBox(width: 4),
                        Wrap(
                          spacing: 12,
                          children: movie.genre 
                              .map(
                                (genre) => Chip(
                                  label: Text(
                                    genre,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red,
                                    ),
                                  ),
                                  backgroundColor: Colors.white12,
                                  side: const BorderSide(color: Colors.transparent),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(0),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.description, 
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete this movie?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _deleteMovie();
                Navigator.of(context).pop(); 
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMovie() {
    MovieService movieService = MovieService();
    movieService.deleteMovie(movie.id!);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Movie deleted successfully')),
    );
  }

  Widget _buildMovieCard(Director director) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: CachedNetworkImage(
                    imageUrl: movie.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                Text(
                  movie.title, 
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Release year: ${movie.releaseYear}',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Director: ${director.firstName} ${director.lastName}',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      "Genres: ",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(width: 4),
                    Wrap(
                      spacing: 12,
                      children: movie.genre
                          .map(
                            (genre) => Chip(
                              label: Text(
                                genre,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                              backgroundColor: Colors.white12,
                              side: const BorderSide(color: Colors.transparent),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(0),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  movie.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _buildDirectorCard(Director person, String formattedDate) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${person.firstName} ${person.lastName}',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                'Born: $formattedDate',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    person.nationality,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Row(
                    children: person.nationalityCode.map((code) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: Flag.fromString(code, height: 20, width: 35),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              FutureBuilder<List<Movie>>(
                future: MovieService().getMoviesByDirector(person.id!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('No movies found for this director.'),
                    );
                  } else {
                    List<Movie> movies = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Their Movies:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: movies.map((movie) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                                ),
                                child: Text(
                                  '${movie.title} (${movie.releaseYear})',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
          if (person.imageFaceUrl != null && person.imageFaceUrl!.isNotEmpty && (person.imageFaceUrl!.startsWith('http') || person.imageFaceUrl!.startsWith('https')))
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Image.network(
                    person.imageFaceUrl!,
                    fit: BoxFit.cover,
                    width: 120,
                    height: 150,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    ),
  );
}

}
