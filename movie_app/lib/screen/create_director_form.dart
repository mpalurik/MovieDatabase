import 'package:flutter/material.dart';
import 'package:movie_app/models/director_model.dart';
import 'package:movie_app/services/director_service.dart';
import 'package:movie_app/widgets/text_form_field_custom.dart';

class CreateDirectorFormPage extends StatefulWidget {
  const CreateDirectorFormPage({super.key});

  @override
  State<CreateDirectorFormPage> createState() => _CreateDirectorFormPageState();
}

class _CreateDirectorFormPageState extends State<CreateDirectorFormPage> {
  final DirectorService directorService = DirectorService();
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for the input fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _bornDateController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _imageFaceUrlController = TextEditingController();
  final TextEditingController _nationalityCodeController = TextEditingController();

  final TextEditingController _secondFirstNameController = TextEditingController();
  final TextEditingController _secondLastNameController = TextEditingController();
  final TextEditingController _secondBornDateController = TextEditingController();
  final TextEditingController _secondNationalityController = TextEditingController();
  final TextEditingController _secondImageFaceUrlController = TextEditingController();
  final TextEditingController _secondNationalityCodeController = TextEditingController();

  int _selectedDirectorCount = 1;

  void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    List<Director> directorsToCreate = [];

    Director firstDirector = Director(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      bornDate: DateTime.parse(_bornDateController.text),
      nationality: _nationalityController.text,
      imageFaceUrl: _imageFaceUrlController.text,
      nationalityCode: _nationalityCodeController.text.toUpperCase().split(','),
    );
    directorsToCreate.add(firstDirector);

    if (_selectedDirectorCount == 2) {
      Director secondDirector = Director(
        firstName: _secondFirstNameController.text,
        lastName: _secondLastNameController.text,
        bornDate: DateTime.parse(_secondBornDateController.text),
        nationality: _secondNationalityController.text,
        imageFaceUrl: _secondImageFaceUrlController.text,
        nationalityCode: _secondNationalityCodeController.text.toUpperCase().split(','),
      );
      directorsToCreate.add(secondDirector);
    }

    try {
      List<Director> createdDirectors = await directorService.createDirectors(directorsToCreate);
      
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Directors are successfully created.")),
      );
      
      // ignore: use_build_context_synchronously
      Navigator.pop(context, createdDirectors);
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Director", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(
          color: Colors.red,
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
              const Text(
                'Select the number of directors to create:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Radio<int>(
                    value: 1,
                    groupValue: _selectedDirectorCount,
                    onChanged: (value) {
                      setState(() {
                        _selectedDirectorCount = value!;
                      });
                    },
                  ),
                  const Text('1 Director'),
                  Radio<int>(
                    value: 2,
                    groupValue: _selectedDirectorCount,
                    onChanged: (value) {
                      setState(() {
                        _selectedDirectorCount = value!;
                      });
                    },
                  ),
                  const Text('2 Directors'),
                ],
              ),

              // First Director Form
              const Text(
                'First Director:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormFieldCustom(
                controller: _firstNameController,
                labelText: 'First Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the first name';
                  }
                  return null;
                },
              ),
              TextFormFieldCustom(
                controller: _lastNameController,
                labelText: 'Last Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the last name';
                  }
                  return null;
                },
              ),
              TextFormFieldCustom(
                controller: _bornDateController,
                labelText: 'Born Date (YYYY-MM-DD)',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the born date';
                  }
                  return null;
                },
              ),
              TextFormFieldCustom(
                controller: _nationalityController,
                labelText: 'Nationality',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the nationality';
                  }
                  return null;
                },
              ),
              TextFormFieldCustom(
                controller: _imageFaceUrlController,
                labelText: 'Image Face URL',
                validator: (value) {
                  return null;
                },
              ),
              TextFormFieldCustom(
                controller: _nationalityCodeController,
                labelText: 'Nationality Code (comma separated)',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the nationality code';
                  }
                  return null;
                },
              ),

              if (_selectedDirectorCount == 2) ...[
                const SizedBox(height: 20),
                const Text(
                  'Second Director:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextFormFieldCustom(
                  controller: _secondFirstNameController,
                  labelText: 'First Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the first name';
                    }
                    return null;
                  },
                ),
                TextFormFieldCustom(
                  controller: _secondLastNameController,
                  labelText: 'Last Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the last name';
                    }
                    return null;
                  },
                ),
                TextFormFieldCustom(
                  controller: _secondBornDateController,
                  labelText: 'Born Date (YYYY-MM-DD)',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the born date';
                    }
                    return null;
                  },
                ),
                TextFormFieldCustom(
                  controller: _secondNationalityController,
                  labelText: 'Nationality',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the nationality';
                    }
                    return null;
                  },
                ),
                TextFormFieldCustom(
                  controller: _secondImageFaceUrlController,
                  labelText: 'Image Face URL',
                  validator: (value) {
                    return null;
                  },
                ),
                TextFormFieldCustom(
                  controller: _secondNationalityCodeController,
                  labelText: 'Nationality Code (comma separated)',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the nationality code';
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submitForm,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
