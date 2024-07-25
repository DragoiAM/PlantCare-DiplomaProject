import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_project/Tools/tools.dart';
import 'package:test_project/firebase_data_saving_page.dart';
import 'Tools/identify_plant.dart';
import 'Tools/consts.dart';
import 'Components/nav_bar.dart';
import 'home_page.dart';
import 'chat_page.dart';
import 'scanned_plant_info_page.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'dart:convert';

class DisplayImageScreen extends StatefulWidget {
  final String imagePath;
  final String userId;
  DisplayImageScreen({
    required this.imagePath,
    required this.userId,
  });

  @override
  _DisplayImageScreenState createState() => _DisplayImageScreenState();
}

class _DisplayImageScreenState extends State<DisplayImageScreen> {
  bool _isLoading = false;
  String _plantInfo = '';
  String plantInfoText = '';
  int? _selectedIndex = null;
  String plantDetails = "";
  String jsonResponse = "";
  String temperature = '0';
  String humidity = '0';
  double sunlight = 0;
  double minTemperature = 0;
  double maxTemperature = 0;
  double minHumidity = 0;
  double maxHumidity = 0;
  static Future<String> _initAsync(String plantName) async {
    String message =
        "Informatii despre planta $plantName in maxim 150 cuvinte.";
    return await getChatResponse(
        message,
        OpenAI.instance.build(
          token: OPENAI_API_KEY,
          baseOption: HttpSetup(
            receiveTimeout: const Duration(
              seconds: 20,
            ),
          ),
          enableLog: true,
        ));
  }

  static Future<String> _initJsonAsync(String plantName) async {
    return getChatResponseJSON(
        plantName,
        OpenAI.instance.build(
          token: OPENAI_API_KEY,
          baseOption: HttpSetup(
            receiveTimeout: const Duration(
              seconds: 20,
            ),
          ),
          enableLog: true,
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigate to HomePage
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  userId: widget.userId,
                )),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatPage(
                  userID: widget.userId,
                )),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPlantInfo();
  }

  Future<void> _loadPlantInfo() async {
    setState(() {
      _isLoading = true;
    });

    String apiKey = PLANTNET_API_KEY;

    String plantName =
        await PlantIdentifier.identifyPlant(widget.imagePath, apiKey);
    plantName = Tools.removeNonAlphabeticCharacters(plantName);
    // Await the response from getChatResponse
    String details = await _initAsync(plantName);
    String json = await _initJsonAsync(plantName);

    setState(() {
      _plantInfo =
          plantName.isNotEmpty ? plantName : 'Unable to identify the plant.';
      plantDetails = details;
      jsonResponse = json;
      Map<String, dynamic> jsonData = jsonDecode(jsonResponse);
      temperature = getPlantTemperature(jsonData);
      humidity = getHumidityPercentage(jsonData);
      sunlight = double.parse(getSunlightExposurePercentage(jsonData));

      minTemperature = double.parse(getPlantTemperatureMin(jsonData));
      maxTemperature = double.parse(getPlantTemperatureMax(jsonData));
      minHumidity = double.parse(getHumidityPercentageMin(jsonData));
      maxHumidity = double.parse(getHumidityPercentageMax(jsonData));

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_isLoading) ...[
              Container(
                color: Theme.of(context).colorScheme.background,
                height: screenHeight,
                width: screenWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    AutoSizeText(
                      "Detectam planta...",
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      minFontSize: 15,
                      maxFontSize: 30,
                    ),
                  ],
                ),
              )
            ] else if (_plantInfo == 'Error Unable to identify the plant') ...[
              Container(
                height: screenHeight,
                width: screenWidth,
                child: Center(
                  child: Container(
                    height: screenHeight * 0.3,
                    width: screenWidth * 0.8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/exclamation.svg', // Path to your SVG file in your assets
                          width: screenWidth * 0.2, // Specify the width
                          height: screenWidth * 0.2, // Specify the height
                          color: Theme.of(context)
                              .colorScheme
                              .onError, // Optional: if you want to apply a color filter
                        ),
                        AutoSizeText(
                          "Planta nu poate fi recunoscuta.",
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 30, // This is the maximum font size
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onError,
                          ),
                          minFontSize: 20,
                          maxFontSize: 50,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ] else ...[
              Column(
                children: [
                  Container(
                    height: screenHeight * 0.6,
                    width: double.infinity,
                    child: Image.file(
                      File(widget.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    color: Theme.of(context).colorScheme.background,
                    height: screenHeight * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: screenWidth * 0.9,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(0, 1),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: AutoSizeText(
                              _plantInfo,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              minFontSize: 20,
                              maxFontSize: 50,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: screenWidth * 0.4,
                                height: screenHeight * 0.2,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,

                                  boxShadow: [
                                    // Optional: if you want a shadow for the container
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(
                                      12), // Optional: if you want rounded corners
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, // Ensure alignment in cross axis
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom:
                                              8.0), // Provide space between the text and the button
                                      child: AutoSizeText(
                                        "Asociaza planta cu senzorii",
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                        minFontSize: 20,
                                        maxFontSize: 30,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            barrierDismissible:
                                                false, // User must not close the dialog manually
                                            builder: (BuildContext context) {
                                              return FirebaseDataSavingPage(
                                                plantNameG: _plantInfo,
                                                detaliiPlanta: plantDetails,
                                                max_temperatura: maxTemperature,
                                                min_temperatura: minTemperature,
                                                max_umiditate: maxHumidity,
                                                min_umiditate: minHumidity,
                                                imagePath: widget.imagePath,
                                                min_luminozitate: sunlight,
                                                userId: widget.userId,
                                              );
                                            });
                                      },
                                      child: AutoSizeText(
                                        "SELECT",
                                        minFontSize: 20,
                                        maxFontSize: 30,
                                        textAlign: TextAlign.center,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        shape: RoundedRectangleBorder(
                                          // Optional: if you want rounded corners
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 32.0,
                                            vertical:
                                                12.0), // Optional: Adjust button padding
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: screenWidth * 0.1,
                              ),
                              Container(
                                width: screenWidth * 0.4,
                                height: screenHeight * 0.2,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  boxShadow: [
                                    // Optional: if you want a shadow for the container
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(
                                      12), // Optional: if you want rounded corners
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, // Ensure alignment in cross axis
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          bottom:
                                              8.0), // Provide space between the text and the button
                                      child: AutoSizeText(
                                        "Afla mai multe informatii",
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                        minFontSize: 20,
                                        maxFontSize: 30,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ScannedPlantInfoPage(
                                                    userId: widget.userId,
                                                    imagePath: widget.imagePath,
                                                    screenHeight: screenHeight,
                                                    screenWidth: screenWidth,
                                                    plantName: _plantInfo,
                                                    plantInfo: plantDetails,
                                                    temperature: temperature,
                                                    humidity: humidity,
                                                    sunlight:
                                                        sunlight.toString(),
                                                  )),
                                        );
                                      },
                                      child: AutoSizeText(
                                        "SELECT",
                                        minFontSize: 20,
                                        maxFontSize: 30,
                                        textAlign: TextAlign.center,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        shape: RoundedRectangleBorder(
                                          // Optional: if you want rounded corners
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 32.0,
                                            vertical:
                                                12.0), // Optional: Adjust button padding
                                      ), // Optional: Adjust button padding
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: _isLoading
          ? Container(
              height: 0,
              width: 0,
            )
          : CustomNavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
    );
  }

  static Future<String> getChatResponse(String message, OpenAI openAi) async {
    try {
      final request = ChatCompleteText(
        model: Gpt4ChatModel(),
        messages: [
          {
            "role": "user",
            "content": message,
          }
        ],
        maxToken: 300,
      );

      final response = await openAi.onChatCompletion(request: request);

      if (response != null &&
          response.choices.isNotEmpty &&
          response.choices[0].message != null) {
        return response.choices[0].message!.content;
      } else {
        return "No response received from the API";
      }
    } catch (e) {
      print("Error fetching data from the API: $e");
      return "An error occurred while fetching data";
    }
  }

  static Future<String> getChatResponseJSON(
      String plantName, OpenAI openAi) async {
    try {
      String message =
          "Provide the following information for the plant '$plantName': in json format , no other text, no signs like % or °C, only value "
          "perfect_temperature_celsius:"
          "min_temperature_celsius:"
          "max_temperature_celsiu:"
          "humidity_percentage:"
          "min_humidity_percentage:"
          "max_humidity_percentage:"
          "sunlight_exposure_percentage:"
          "min_sunlight_exposure_percentage:"
          "max_sunlight_exposure_percentage:";

      final request = ChatCompleteText(
        model: Gpt4ChatModel(),
        messages: [
          {
            "role": "user",
            "content": message,
          }
        ],
        maxToken: 300,
      );

      final response = await openAi.onChatCompletion(request: request);

      if (response != null &&
          response.choices.isNotEmpty &&
          response.choices[0].message != null) {
        final content = response.choices[0].message!.content;
        return content;
      } else {
        return jsonEncode({'error': 'No valid response received from the API'});
      }
    } catch (e) {
      print("Error fetching data from the API: $e");
      return jsonEncode({'error': 'Exception occurred during API call'});
    }
  }

  String getPlantTemperature(Map<String, dynamic> jsonData) {
    if (jsonData['perfect_temperature_celsius'] == null) {
      return '25';
    } else {
      return jsonData['perfect_temperature_celsius'].toString();
    }
  }

  String getHumidityPercentage(Map<String, dynamic> jsonData) {
    if (jsonData['humidity_percentage'] == null) {
      return '30';
    } else {
      return jsonData['humidity_percentage'].toString();
    }
  }

  String getSunlightExposurePercentage(Map<String, dynamic> jsonData) {
    if (jsonData['sunlight_exposure_percentage'] == null) {
      return '50';
    } else {
      return jsonData['sunlight_exposure_percentage'].toString();
    }
  }

  String getPlantTemperatureMin(Map<String, dynamic> jsonData) {
    if (jsonData['min_temperature_celsius'] == null) {
      return '20';
    } else {
      return jsonData['min_temperature_celsius'].toString();
    }
  }

  String getPlantTemperatureMax(Map<String, dynamic> jsonData) {
    if (jsonData['max_temperature_celsius'] == null) {
      return '30';
    } else {
      return jsonData['max_temperature_celsius'].toString();
    }
  }

  String getHumidityPercentageMin(Map<String, dynamic> jsonData) {
    if (jsonData['min_humidity_percentage'] == null) {
      return '20';
    } else {
      return jsonData['min_humidity_percentage'].toString();
    }
  }

  String getHumidityPercentageMax(Map<String, dynamic> jsonData) {
    if (jsonData['max_humidity_percentage'] == null) {
      return '50';
    } else {
      return jsonData['max_humidity_percentage'].toString();
    }
  }
}
