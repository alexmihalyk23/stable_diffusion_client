import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'ImagePage.dart';
import 'LifecycleEventHandler.dart';
import 'local_notification.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

double sliderValue = 10;
String? dropdownValue = "Webui";
String? dropdownVal = "f";
bool _isLoading = false;
double firstSliderValue = 64;
double secondSliderValue = 64;
String? modelValue = "Anime.safetensors [b458c54ea7]";

TextEditingController promptController = TextEditingController();
TextEditingController negativePromptController = TextEditingController(
    text:
        "(worst quality, mutated hands and fingers, bad anatomy, wrong anatomy, mutation:1.2)");
TextEditingController serverAddressController = TextEditingController();

class txt2imgPage extends StatefulWidget {
  const txt2imgPage(
      {super.key, required String base64Image, required String serverAddress});

  @override
  State<txt2imgPage> createState() => _txt2imgPageState();
}

class _txt2imgPageState extends State<txt2imgPage> {
  String? base64Image;
  List<String> lorasList = [];

  String? srvAddr = serverAddressController.text;
  bool _isButtonDisabled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LocalNotification.initialize(flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Txt2Img Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // DropdownButton<String>(
              //   value:
              //       dropdownValue, // Устанавливаем текущее выбранное значение
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       dropdownValue =
              //           newValue; // Обновляем выбранное значение при изменении
              //     });
              //   },
              //   items: <String>['Webui', 'cpp']
              //       .map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              // ),
              DropdownButton<String>(
                value: modelValue,
                onChanged: (String? newValue) {
                  setState(() {
                    modelValue = newValue;
                    Map<String, String> modelT = {
                      'sd_model_checkpoint': modelValue.toString()
                    };
                    http.post(
                        Uri.parse(
                            "${serverAddressController.text}/sdapi/v1/options"),
                        body: jsonEncode(modelT),
                        headers: {
                          'Content-Type': 'application/json'
                        }).then((response) {
                      if (response.statusCode == 200) {
                        print(response.body);
                        // Действия при успешной отправке данных
                      } else {
                        print(response.body);
                      }
                    });
                  });
                },
                items: <String>[
                  "Anime.safetensors [b458c54ea7]",
                  "deliberate_v3.safetensors [aadddd3d75]",
                  "reliberate_v20.safetensors [6b08e2c182]"
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextField(
                controller: promptController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Введите промпт',
                ),
              ),
              TextField(
                controller: negativePromptController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Введите негативный промпт',
                  hintStyle: TextStyle(color: Colors.red),
                ),
              ),


              // ElevatedButton(
              //   style: ButtonStyle(
              //     backgroundColor:
              //     MaterialStateProperty.resolveWith<Color>((states) {
              //       if (states.contains(MaterialState.disabled)) {
              //         return Colors.orange.withOpacity(
              //             0.5); // Измените цвет кнопки при неактивном состоянии
              //       }
              //       return Colors
              //           .orange; // Измените цвет кнопки при активном состоянии
              //     }),
              //     shape: MaterialStateProperty.all(RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(25),
              //     )),
              //     foregroundColor: MaterialStateProperty.all(Colors.white),
              //     minimumSize: MaterialStateProperty.all(const Size(150, 45)),
              //   ),
              //   onPressed: _isButtonDisabled ? null : _getLoras,
              //   child: const Text(
              //     'Loras',
              //     style: TextStyle(fontSize: 20),
              //   ),
              // ),

              // Добавить DropdownMenu для выбора Loras
              DropdownButton<String>(
                value: dropdownVal,
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownVal = newValue;
                    promptController.text+=" <lora:$dropdownVal:0.75>,";
                  });
                },
                items: lorasList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),


              Slider(
                value: firstSliderValue,
                min: 64,
                max: 1024,
                divisions: 15,
                label: firstSliderValue.round().toString(),
                onChanged: (double newValue) {
                  setState(() {
                    firstSliderValue = newValue;
                  });
                },
              ),
              Text('Ширина изображения: ${firstSliderValue.round()}'),
              Slider(
                value: secondSliderValue,
                min: 64,
                max: 1024,
                divisions: 15,
                label: secondSliderValue.round().toString(),
                onChanged: (double newValue) {
                  setState(() {
                    secondSliderValue = newValue;
                  });
                },
              ),
              Text('высота изображения: ${secondSliderValue.round()}'),
              Slider(
                value: sliderValue,
                min: 10,
                max: 40,
                divisions: 30,
                label: sliderValue.round().toString(),
                onChanged: (double newValue) {
                  setState(() {
                    sliderValue = newValue;
                  });
                },
              ),
              Text('Количество шагов: ${sliderValue.round()}'),

              // Stack(
              //   children: [

              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.orange.withOpacity(
                          0.5); // Измените цвет кнопки при неактивном состоянии
                    }
                    return Colors
                        .orange; // Измените цвет кнопки при активном состоянии
                  }),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  )),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  minimumSize: MaterialStateProperty.all(const Size(150, 45)),
                ),
                onPressed: _isButtonDisabled ? null : _handleButtonTap,
                child: const Text(
                  'генерация',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                width: 10,
                height: 10,
              ),
              Stack(
                children: [
                  if (_isButtonDisabled)
                    const Positioned(
                      child: LinearProgressIndicator(),
                    ),
                ],
              ),

              // ],),
              if (base64Image != null)
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImagePage(
                        base64Image: base64Image!,
                        serverAddress: serverAddressController.text!,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16), // Добавление отступа
                    child: Image.memory(
                      base64Decode(base64Image!),
                      width: 512,
                      height: 512,
                    ),
                  ),
                ),
              TextField(
                controller: serverAddressController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Введите адрес сервера',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getLoras() async {
    String serverAddress = serverAddressController.text;
    var url = Uri.parse("$serverAddress/sdapi/v1/loras");
    var response = await http.get(url);

    List<dynamic> jsonList = json.decode(response.body);
    lorasList.clear();
    for (var item in jsonList) {
      String name = item['name'];
      lorasList.add(name);
    }
    setState(() {});
  }




  void _handleButtonTap() {
    _getLoras();
    setState(() {
      _isLoading = true;
    });
    _isButtonDisabled = !_isButtonDisabled;
    String prompt = promptController.text;
    String negativePrompt = negativePromptController.text;
    String serverAddress = serverAddressController.text;

    Map<String, String> data = {
      'prompt': prompt,
      'negative_prompt': negativePrompt,
      'steps': sliderValue.toInt().toString(),
      'width': firstSliderValue.toInt().toString(),
      'height': secondSliderValue.toInt().toString(),
      'restore_faces': false.toString()
    };

    http.post(Uri.parse("$serverAddress/sdapi/v1/txt2img"),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'}).then((response) {
      if (response.statusCode == 200) {
        print(response.body);
        String base64Image = jsonDecode(response.body)['images'][0];

        // if(Platform.isAndroid)
        if (!lifecycleEventHandler.inBackground) {
          print("dddddddddd");
        } else {
          LocalNotification.showBigTextNotification(
              title: 'Stable Diffusion Client',
              body: "Изображение Сгенерированно",
              flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin);
        }

        setState(() {
          this.base64Image = base64Image;
          _isButtonDisabled = !_isButtonDisabled;
        });
      } else {
        print(response.body);
        _isButtonDisabled = false;
        setState(() {
          _isLoading = false;
        });
      }
      _isButtonDisabled = false;
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {
      print(error);
      _isButtonDisabled = false;
      setState(() {
        _isLoading = false;
      });
    });
  }
}
