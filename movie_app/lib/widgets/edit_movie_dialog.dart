import 'package:flutter/material.dart';
import 'package:movie_app/models/director_model.dart';
import 'package:movie_app/models/movie_model.dart';
import 'package:movie_app/services/director_service.dart';
import 'package:movie_app/widgets/text_form_field_custom.dart';

class EditMovieDialog extends StatefulWidget {
  final Movie movie;
  final Function(Movie) onSave;

  const EditMovieDialog({
    super.key,
    required this.movie,
    required this.onSave,
  });

  @override
  State<EditMovieDialog> createState() => _EditMovieDialogState();
}

class _EditMovieDialogState extends State<EditMovieDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _releaseYearController;
  late TextEditingController _genreController;
  late TextEditingController _imageUrlController;
  late TextEditingController _descriptionController;

  late List<Director> directors = [];
  String? _selectedDirectorId;
  final DirectorService _directorService = DirectorService();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with movie data
    _titleController = TextEditingController(text: widget.movie.title);
    _releaseYearController = TextEditingController(text: widget.movie.releaseYear.toString());
    _genreController = TextEditingController(text: widget.movie.genre.join(',').trim());
    _imageUrlController = TextEditingController(text: widget.movie.imageUrl);
    _descriptionController = TextEditingController(text: widget.movie.description);
    _selectedDirectorId = widget.movie.directorId;

    // Fetch directors asynchronously
    _fetchDirectors();
  }

  Future<void> _fetchDirectors() async {
    directors = await _directorService.getDirectors(); // Awaiting the future here
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _releaseYearController.dispose();
    _genreController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Edit Movie",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white
                  ),
                ),
                const SizedBox(height: 10),
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
                  labelText: 'Genres (comma separated)',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the genres';
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
                if (directors.isNotEmpty) 
                  DropdownButtonFormField<String>(
                    borderRadius: BorderRadius.circular(8),
                    focusColor: Theme.of(context).colorScheme.primary,
                    value: _selectedDirectorId,
                    
                    items: directors.map((director) {
                      return DropdownMenuItem<String>(
                        value: director.id.toString(),
                        child: FittedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Optional, aligns text to the left
                            children: [
                              Text('${director.firstName} ${director.lastName}',style: const TextStyle(fontSize: 12),),
                              if (director.id != null && director.id!.isNotEmpty) // Corrected condition here
                                Text(director.id.toString(),style: const TextStyle(fontSize: 10)), // Ensure to display the id as text
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDirectorId = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Director',
                      labelStyle: const TextStyle(color: Colors.white),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusColor: Theme.of(context).colorScheme.primary,
                      floatingLabelStyle:  const TextStyle(color: Colors.white,),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    dropdownColor: const Color.fromRGBO(124, 48, 48, 1),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a director';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Create an updated Movie object
                        Movie updatedMovie = Movie(
                          title: _titleController.text,
                          releaseYear: int.parse(_releaseYearController.text),
                          genre: _genreController.text.split(','),
                          imageUrl: _imageUrlController.text,
                          description: _descriptionController.text,
                          directorId: _selectedDirectorId!, // Use _selectedDirectorId
                        );
                        // Pass updated movie to the onSave callback
                        widget.onSave(updatedMovie);
                        Navigator.pop(context); // Close the dialog
                        Navigator.pop(context);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary)
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
