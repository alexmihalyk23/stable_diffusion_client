import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class extrasPage extends StatefulWidget {
  const extrasPage({super.key});

  @override
  _extrasPageState createState() => _extrasPageState();
}

class _extrasPageState extends State<extrasPage> {
  File? _image;

  Future<void> openImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Extras Page'),
      ),
      body: Center(
        child: _image != null
            ? Image.file(_image!)
            : const Text('No image selected'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openImage,
        child: const Icon(Icons.image),
      ),
    );
  }
}
