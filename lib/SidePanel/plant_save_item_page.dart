import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';

class SavedPlantInfoPage extends StatefulWidget {
  final String imagePath;
  final double screenWidth;
  final double screenHeight;
  final String plantName;
  final String plantInfo;
  final String temperature;
  final String humidity;
  final String sunlight;

  // Include other fields...

  const SavedPlantInfoPage({
    Key? key,
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
  _SavedPlantInfoPageState createState() => _SavedPlantInfoPageState();
}

class _SavedPlantInfoPageState extends State<SavedPlantInfoPage> {
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
                    child: Image.network(
                      widget.imagePath.toString(),
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null)
                          return child; // Image is fully loaded
                        return Center(
                          // Show loading indicator while image is loading
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        // Optionally handle errors, such as when the image cannot be loaded
                        return Text('Eroare la incarcarea imaginii');
                      },
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
              ],
            ),
          ),
        ),
      ),
    );
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
