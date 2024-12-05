import 'package:flutter/material.dart';

class TextFormFieldCustom extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  // Constructor with named parameters
  const TextFormFieldCustom({
    super.key,
    required this.controller,
    required this.labelText,
    required this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          focusColor: Theme.of(context).colorScheme.primary,
          floatingLabelStyle: const TextStyle(color: Colors.white,),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(8)
          ),
        ),
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.red,
        validator: validator,
        keyboardType: keyboardType,
      ),
    );
  }
}
