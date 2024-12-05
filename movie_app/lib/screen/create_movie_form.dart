import 'package:flutter/material.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/services/movie_service.dart';
import 'package:movie_app/widgets/text_form_field_custom.dart';

class CreateMovieFormPage extends StatefulWidget {
  const CreateMovieFormPage({super.key});

  @override
  State<CreateMovieFormPage> createState() => _CreateMovieFormPageState();
}

class _CreateMovieFormPageState extends State<CreateMovieFormPage> {
  final MovieService movieService = MovieService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _releaseYearController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _directorIdController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Movie newMovie = Movie(
        title: _titleController.text,
        releaseYear: int.parse(_releaseYearController.text),
        genre: _genreController.text.split(','),
        imageUrl: _imageUrlController.text,
        description: _descriptionController.text,
        directorId: _directorIdController.text,
      );

      movieService.createMovie(newMovie).then((movie) {
        // Handle the response, maybe go back or show success message
        // ignore: use_build_context_synchronously
        Navigator.pop(context, movie); // Here we can use context to pop the screen
      }).catchError((error) {
        // Handle error (e.g., show error message)
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Movie", style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(
    color: Colors.red, //change your color here
  ),
  shadowColor: Colors.transparent,
  surfaceTintColor: Colors.white,
  backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
            TextFormFieldCustom(
                controller: _titleController,
                labelText: 'Title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              TextFormFieldCustom(
                controller: _releaseYearController,
                labelText: 'Release Year',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the release year';
                  }
                  return null;
                },
              ),
              TextFormFieldCustom(
                controller: _genreController,
                labelText: 'Genre (comma separated)',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the genre';
                  }
                  return null;
                },
              ),
              TextFormFieldCustom(
                controller: _imageUrlController,
                labelText: 'Image URL',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the image URL';
                  }
                  return null;
                },
              ),
              TextFormFieldCustom(
                controller: _descriptionController,
                labelText: 'Description',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the description';
                  }
                  return null;
                },
              ),
              TextFormFieldCustom(
                controller: _directorIdController,
                labelText: 'Director ID',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the director ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submitForm,
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red), // Fixed name
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}