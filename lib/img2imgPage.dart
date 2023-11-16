import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



class img2imgPage extends StatefulWidget {
  const img2imgPage({super.key});

  @override
  _img2imgPageState createState() => _img2imgPageState();
}

class _img2imgPageState extends State<img2imgPage> {
  // File? _image;
  //
  // Future<void> openImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Img2Img Page'),

      ),

    );
  }
}
