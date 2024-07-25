import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'dart:io';

import 'package:test_project/Tools/plant_saved_class.dart';

class ScannedPlantInfoPage extends StatefulWidget {
  final String userId;
  final String imagePath;
  final double screenWidth;
  final double screenHeight;
  final String plantName;
  final String plantInfo;
  final String temperature;
  final String humidity;
  final String sunlight;

  // Include other fields...

  const ScannedPlantInfoPage({
    Key? key,
    required this.userId,
    required this.screenWidth,
    required this.screenHeight,
    required this.imagePath,
    required this.plantName,
    required this.plantInfo,
    required this.temperature,
    required this.humidity,
    required this.sunlight,
  }) : super(key: key);

  @override
  _ScannedPlantInfoPageState createState() => _ScannedPlantInfoPageState();
}

class _ScannedPlantInfoPageState extends State<ScannedPlantInfoPage> {
  bool isButtonVisible = true;

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must not close the dialog manually
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text(
                  "Se salvează...",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _checkSavedState();
  }

  Future<void> _checkSavedState() async {
    var box = Hive.box('plantSavedBoxScanned');
    // Assuming you have a way to determine the current plant's ID on page load
    bool isSaved = box.get('isSaved_${widget.plantName}', defaultValue: false);
    setState(() {
      isButtonVisible = !isSaved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          widget.plantName,
          minFontSize: 20,
          maxFontSize: 50,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.clip,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: widget.screenWidth * 0.05,
            right: widget.screenWidth * 0.05,
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: widget.screenHeight * 0.35,
                  width: widget.screenWidth * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.all(widget.screenHeight * 0.02),
                  child: Padding(
                    padding: EdgeInsets.all(widget.screenWidth * 0.02),
                    child: Image.file(
                      File(widget.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
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
                    children: [
                      AutoSizeText(
                        'Informatii',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 30, // This is the maximum font size
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        minFontSize: 20,
                        maxFontSize: 50,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                      AutoSizeText(
                        "Parametrii preferati de planta:",
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 15, // This is the maximum font size
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        minFontSize: 10,
                        maxFontSize: 20,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _itemPreference('assets/icons/temperature.svg',
                              widget.temperature + "°C", context),
                          _itemPreference('assets/icons/drop.svg',
                              widget.humidity + "%", context),
                          _itemPreference(
                              'assets/icons/sun.svg', widget.sunlight, context),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(widget.screenWidth * 0.05),
                        child: AutoSizeText(
                          widget.plantInfo,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 15, // This is the maximum font size
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          minFontSize: 5,
                          maxFontSize: 30,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0.025 * widget.screenHeight,
                ),
                if (isButtonVisible)
                  TextButton(
                    onPressed: () => _savePlantInfo(context),
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: AutoSizeText(
                      'Salveaza informatiile despre planta',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Assuming fetchAndStorePlants is defined correctly elsewhere and accessible here
  Future<void> _savePlantInfo(BuildContext context) async {
    _showLoadingDialog(context);
    try {
      PlantSaved plantSaved = PlantSaved(
          userId: widget.userId,
          plantName: widget.plantName,
          plantInfo: widget.plantInfo,
          temperature: widget.temperature,
          humidity: widget.humidity,
          sunlight: widget.sunlight,
          imagePath: widget.imagePath);

      await plantSaved.save(); // Save to Firestore
      await plantSaved.fetchAndStorePlants(
          widget.userId); // Fetch from Firestore and save to Hive

      var boxS = Hive.box('plantSavedBoxScanned');
      await boxS.put(
          'isSaved_${plantSaved.plantName}', true); // Flag set in Hive
      setState(() {
        isButtonVisible = false; // Hide the button after successful operation
      });
    } finally {
      Navigator.of(context).pop(); // Close the loading dialog
      _showSnackBar(context, "Planta a fost salvata cu succes!");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: AutoSizeText(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _itemPreference(
    String pathImage,
    String text,
    BuildContext context,
  ) {
    if (pathImage.contains('sun.svg')) {
      double sunlightValue = double.parse(text);
      text = sunlightValue.toInt().toString() + "%";
    }
    return Container(
      margin: EdgeInsets.only(
        left: 0.08 * widget.screenWidth,
        right: 0.08 * widget.screenWidth,
        top: 0.02 * widget.screenWidth,
        bottom: 0.02 * widget.screenWidth,
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            pathImage,
            width: 0.08 * widget.screenWidth,
            height: 0.08 * widget.screenWidth,
          ),
          AutoSizeText(
            text,
            style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 20, // This is the maximum font size
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            minFontSize: 5,
            maxFontSize: 30,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
          ),
        ],
      ),
    );
  }
}
