import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stable_diffusion_client/local_notification.dart';

double _upscalingValue = 1.0;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class ImagePage extends StatefulWidget {
  final String base64Image;
  final String serverAddress;

  const ImagePage(
      {Key? key, required this.base64Image, required this.serverAddress})
      : super(key: key);

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  void initState() {
    super.initState();
    LocalNotification.initialize(flutterLocalNotificationsPlugin);
  }

  bool _isButtonDisabled = true;
  bool _isLoading = false;
  String Img = '';
  final notificationID = 1;

  void loadImage() {
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> data = {
      "resize_mode": 0,
      "show_extras_results": true,
      "gfpgan_visibility": 0,
      "codeformer_visibility": 0,
      "codeformer_weight": 0,
      "upscaling_resize": _upscalingValue,
      "upscaling_resize_w": 512,
      "upscaling_resize_h": 512,
      "upscaling_crop": true,
      "upscaler_1": "R-ESRGAN 4x+",
      "upscaler_2": "None",
      "extras_upscaler_2_visibility": 0,
      "upscale_first": false,
      "image": widget.base64Image
    };

    String text = widget.serverAddress;

    http.post(
      Uri.parse("${text}/sdapi/v1/extra-single-image"),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    ).then((response) {
      if (response.statusCode == 200) {
        String base64Image = jsonDecode(response.body)["image"];
        setState(() {
          this.Img = base64Image;
          _isLoading = false;
          _isButtonDisabled = true;
        });
      } else {
        print(response.body);
        _isButtonDisabled = true;
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Изображение'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InteractiveViewer(
                child: Image.memory(
                  base64Decode(widget.base64Image),
                  fit: BoxFit.contain,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  var srv = widget.serverAddress;
                  if (Img.isNotEmpty) {
                    Img = Img;
                  } else {
                    Img = widget.base64Image;
                  }
                  if (Platform.isAndroid) {
                    final result = await ImageGallerySaver.saveImage(
                      Uint8List.fromList(base64Decode(Img)),
                    );
                    LocalNotification.showBigTextNotification(
                      title: 'Stable Diffusion Client',
                      body: "Изображение Сохранено",
                      flutterLocalNotificationsPlugin:
                          flutterLocalNotificationsPlugin,
                    );
                  } else {
                    final directory = await getApplicationDocumentsDirectory();
                    final currentTime = DateTime.now().millisecondsSinceEpoch;
                    final imagePath =
                        '${directory.path}/image_$currentTime.png';
                    final imageFile = File(imagePath);
                    await imageFile.writeAsBytes(base64Decode(Img));
                    LocalNotification.showBigTextNotification(
                      title: 'Stable Diffusion Client',
                      body: "Изображение Сохранено",
                      flutterLocalNotificationsPlugin:
                          flutterLocalNotificationsPlugin,
                    );
                  }
                },
                child: const Text('Сохранить изображение',
                    style: TextStyle(fontSize: 25)),
              ),
              SizedBox(
                width: 10,
                height: 10,
              ),
              AbsorbPointer(
                absorbing: _isLoading,
                child: ElevatedButton(
                  onPressed: !_isButtonDisabled
                      ? null
                      : () {
                          _isButtonDisabled = false;
                          loadImage();
                        },
                  child: const Text(
                    'Улучшить изображение',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
              Slider(
                value: _upscalingValue,
                min: 1.0,
                max: 4.0,
                divisions: 3,
                label: _upscalingValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _upscalingValue = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
