import 'package:flutter/material.dart';
import 'package:stable_diffusion_client/img2imgPage.dart';

import 'LifecycleEventHandler.dart';
import 'txt2imgPage.dart';
import 'extrasPage.dart';

// bool _iconBool = false;
// IconData _iconLight = Icons.wb_sunny;
// IconData _iconDark = Icons.nights_stay;
//
//
//
// ThemeData _lightTheme = ThemeData(
//     primarySwatch: Colors.amber,
//     brightness: Brightness.light
// );
ThemeData _darkTheme =
    ThemeData(primarySwatch: Colors.red, brightness: Brightness.dark);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  lifecycleEventHandler.init();
  runApp(MaterialApp(
    home: const MyApp(),
    theme: _darkTheme,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const txt2imgPage(
      base64Image: '',
      serverAddress: '',
    ),
    img2imgPage(),
    extrasPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stable Diffusion client'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: 'txt2img',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'img2img',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.extension),
            label: 'extras',
          ),
        ],
      ),
    );
  }
}
