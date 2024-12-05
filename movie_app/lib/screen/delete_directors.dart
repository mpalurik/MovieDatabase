import 'package:flutter/material.dart';
import 'package:movie_app/models/director_model.dart';
import 'package:movie_app/services/director_service.dart';

class DeleteDirectorsPage extends StatefulWidget {
  const DeleteDirectorsPage({super.key});

  @override
  State<DeleteDirectorsPage> createState() => _DeleteDirectorsPageState();
}

class _DeleteDirectorsPageState extends State<DeleteDirectorsPage> {
  late Future<List<Director>> directors;
  Set<String> selectedDirectors = {};
  final DirectorService directorService = DirectorService();

  @override
  void initState() {
    super.initState();
    directors = directorService.getDirectors();
  }


  Future<void> deleteSelectedDirectors() async {
    if (selectedDirectors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No directors selected for deletion')),
      );
      return;
    }

    try {
      await directorService.deleteMultipleDirectors(selectedDirectors.toList());
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selected directors deleted successfully')),
      );

      setState(() {
        directors = directorService.getDirectors();
        selectedDirectors.clear();
      });

      // ignore: use_build_context_synchronously
      Navigator.pop(context,);
      // ignore: use_build_context_synchronously
      Navigator.pop(context,);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Directors'),
      ),
      body: FutureBuilder<List<Director>>(
        future: directors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No directors found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final director = snapshot.data![index];
                return ListTile(
                  title: Text('${director.firstName} ${director.lastName}'),
                  trailing: Checkbox(
                    value: selectedDirectors.contains(director.id),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedDirectors.add(director.id!);
                        } else {
                          selectedDirectors.remove(director.id);
                        }
                      });
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: deleteSelectedDirectors,
        tooltip: 'Delete Selected Directors',
        child: const Icon(Icons.delete),
      ),
    );
  }
}