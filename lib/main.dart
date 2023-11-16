import 'package:flutter/material.dart';
import 'package:stable_diffusion_client/img2imgPage.dart';

import 'LifecycleEventHandler.dart';
import 'txt2imgPage.dart';
import 'extrasPage.dart';
bool _iconBool = false;
IconData _iconLight = Icons.wb_sunny;
IconData _iconDark = Icons.nights_stay;



ThemeData _lightTheme = ThemeData(
    primarySwatch: Colors.amber,
    brightness: Brightness.light
);
ThemeData _darkTheme = ThemeData(
    primarySwatch: Colors.red,
    brightness: Brightness.dark
);
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  lifecycleEventHandler.init();
  runApp(MaterialApp(
    home: const MyApp(),
    theme: _darkTheme,
  ));
}




double sliderValue = 10;
String? dropdownValue = "Webui";
double firstSliderValue = 64;
double secondSliderValue = 64;
String? modelValue = "Anime.safetensors [b458c54ea7]";

TextEditingController promptController = TextEditingController();
TextEditingController negativePromptController = TextEditingController(text: "(worst quality, mutated hands and fingers, bad anatomy, wrong anatomy, mutation:1.2)");
TextEditingController serverAddressController = TextEditingController(text: "http://192.168.31.146:7861");


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const txt2imgPage(base64Image: '', serverAddress: '',),
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

//
// class _MyAppState extends State<MyApp> {
//   String? base64Image;
//   bool _isButtonDisabled = false;
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//         appBar: AppBar(
//
//           title: Text('Stable Diffusion client'),
//           // actions: [IconButton(
//           //   onPressed: () {
//           //     setState(() {
//           //       _iconBool = !_iconBool;
//           //     });
//           //   },
//           //   icon: Icon(_iconBool ? _iconDark : _iconLight),
//           // ),],
//         ),
//         body: SingleChildScrollView(
//         child:
//         Padding(
//         padding: EdgeInsets.all(10),
//           child: Column(
//             // mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               DropdownButton<String>(
//                 value:
//                     dropdownValue, // Устанавливаем текущее выбранное значение
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     dropdownValue =
//                         newValue; // Обновляем выбранное значение при изменении
//                   });
//                 },
//                 items: <String>['Webui', 'cpp']
//                     .map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//               DropdownButton<String>(
//                 value: modelValue,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     modelValue = newValue;
//                     Map<String, String> modelT = {
//                       'sd_model_checkpoint': modelValue.toString()
//
//                     };
//                     http.post(Uri.parse(serverAddressController.text + "/sdapi/v1/options"),
//                         body: jsonEncode(modelT),
//                         headers: {
//                           'Content-Type': 'application/json'
//                         }).then((response) {
//
//                       if (response.statusCode == 200) {
//                         print(response.body);
//                         // Действия при успешной отправке данных
//                       } else {
//                         print(response.body);
//                       }
//                     });
//                   });
//                 },
//                 items: <String>[
//                   "Anime.safetensors [b458c54ea7]",
//                   "deliberate_v3.safetensors [aadddd3d75]",
//                   "reliberate_v20.safetensors [6b08e2c182]"
//                 ].map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//               TextField(
//                 controller: promptController,
//                 maxLines: null,
//                 decoration: InputDecoration(
//                   hintText: 'Введите промпт',
//                 ),
//               ),
//               TextField(
//                 controller: negativePromptController,
//                 maxLines: null,
//                 decoration: InputDecoration(
//                   hintText: 'Введите негативный промпт',
//                   hintStyle: TextStyle(color: Colors.red),
//                 ),
//               ),
//               Slider(
//                 value: firstSliderValue,
//                 min: 64,
//                 max: 1024,
//                 divisions: 15,
//                 label: firstSliderValue.round().toString(),
//                 onChanged: (double newValue) {
//                   setState(() {
//                     firstSliderValue = newValue;
//                   });
//                 },
//               ),
//               Text('Ширина изображения: ${firstSliderValue.round()}'),
//               Slider(
//                 value: secondSliderValue,
//                 min: 64,
//                 max: 1024,
//                 divisions: 15,
//                 label: secondSliderValue.round().toString(),
//                 onChanged: (double newValue) {
//                   setState(() {
//                     secondSliderValue = newValue;
//                   });
//                 },
//               ),
//               Text('высота изображения: ${secondSliderValue.round()}'),
//               Slider(
//                 value: sliderValue,
//                 min: 10,
//                 max: 40,
//                 divisions: 30,
//                 label: sliderValue.round().toString(),
//                 onChanged: (double newValue) {
//                   setState(() {
//                     sliderValue = newValue;
//                   });
//                 },
//               ),
//               Text('Количество шагов: ${sliderValue.round()}'),
//
//           Stack(
//             children: [
//
//               ElevatedButton(
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(Colors.orange),
//                   shape: MaterialStateProperty.all(RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   )),
//                   foregroundColor: MaterialStateProperty.all(Colors.white),
//                   minimumSize: MaterialStateProperty.all(Size(150, 50)),
//
//                 ),
//                 onPressed: _isButtonDisabled ? null : _handleButtonTap,
//                 child: Text('генерация', style: TextStyle(fontSize: 20),),
//               ), ],),
//               if (base64Image != null)
//                 GestureDetector(
//                   onTap: () =>  Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ImagePage(base64Image: base64Image!),
//       ),
//     ), // Pass the context here
//                   child: Image.memory(
//                     base64Decode(base64Image!),
//                     width: 512,
//                     height: 512,
//                   ),
//                 ),
//               TextField(
//                 controller: serverAddressController,
//                 maxLines: null,
//                 decoration: InputDecoration(
//                   hintText: 'Введите адрес сервера',
//                 ),
//               ),
//             ],
//           ),
//         ),
//         ),
//     );
//
//
//   }
//
// }
