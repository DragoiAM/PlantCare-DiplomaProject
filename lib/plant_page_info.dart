import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_project/Components/SVGLeft.dart';
import 'package:test_project/Tools/plant_class.dart';
import '/Components/ProgressIndicatorWithSvgLeft.dart';
import '/../Tools/tools.dart';

class PlantPageInfo extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final String userId;
  final Plant plant;

  const PlantPageInfo({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.userId,
    required this.plant,
  });

  @override
  _PlantPageInfoState createState() => _PlantPageInfoState();
}

class _PlantPageInfoState extends State<PlantPageInfo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          widget.plant.numePlanta,
          style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          minFontSize: 25,
          maxFontSize: 65,
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
                  ),
                  margin: EdgeInsets.all(widget.screenHeight * 0.02),
                  child: Padding(
                    padding: EdgeInsets.all(widget.screenWidth * 0.04),
                    child: Image.network(
                      widget.plant.imagine.toString(),
                      fit: BoxFit.cover,
                      // Remove the initial CircularProgressIndicator from the Stack.
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
                        return Text('Error loading image');
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProgressIndicatorWithSvgLeft(
                      screenWidth: widget.screenWidth,
                      screenHeight: widget.screenHeight,
                      progress: Tools.percentCalculator(
                          widget.plant.sol.soilTemperatura,
                          widget.plant.sol.minSoilTemperatura,
                          widget.plant.sol.maxSoilTemperatura),
                      text: "${widget.plant.sol.soilTemperatura.round()}°C",
                      assetPath: 'assets/icons/temperature.svg',
                      titleText: 'Temperatura sol',
                    ),
                    SizedBox(
                      width: 0.05 * widget.screenWidth,
                    ),
                    ProgressIndicatorWithSvgLeft(
                      screenWidth: widget.screenWidth,
                      screenHeight: widget.screenHeight,
                      progress: Tools.percentCalculator(
                          widget.plant.sol.soilUmiditate,
                          widget.plant.sol.minSoilUmiditate,
                          widget.plant.sol.maxSoilUmiditate),
                      text: "${widget.plant.sol.soilUmiditate.round()}%",
                      assetPath: 'assets/icons/drop.svg',
                      titleText: 'Umiditate sol',
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.01 * widget.screenHeight,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProgressIndicatorWithSvgLeft(
                      screenWidth: widget.screenWidth,
                      screenHeight: widget.screenHeight,
                      progress: Tools.percentCalculator(
                          widget.plant.lumina.lumina,
                          widget.plant.lumina.minLumina,
                          100),
                      text: "${widget.plant.lumina.lumina.round()}%",
                      assetPath: 'assets/icons/sun.svg',
                      titleText: 'Luminozitate',
                    ),
                    SizedBox(
                      width: 0.05 * widget.screenWidth,
                    ),
                    SVGLeft(
                      screenWidth: widget.screenWidth,
                      screenHeight: widget.screenHeight,
                      text:
                          "${DateTime.now().difference(widget.plant.pompa.ultimaUdare).inHours} h",
                      assetPath: 'assets/icons/drop.svg',
                      titleText: 'Ultima irigare',
                    ),
                  ],
                ),
                SizedBox(
                  height: 0.025 * widget.screenHeight,
                ),
                AutoSizeText(
                  'Informatii despre planta',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  minFontSize: 25,
                  maxFontSize: 65,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                SizedBox(
                  height: 0.025 * widget.screenHeight,
                ),
                Container(
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
                  child: Column(
                    children: [
                      AutoSizeText(
                        "Parametrii preferati de planta:",
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        minFontSize: 5,
                        maxFontSize: 25,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ItemPreference('assets/icons/temperature.svg',
                              "${(widget.plant.sol.minSoilTemperatura + widget.plant.sol.maxSoilTemperatura) / 2}°C"),
                          ItemPreference('assets/icons/drop.svg',
                              "${(widget.plant.sol.minSoilUmiditate + widget.plant.sol.maxSoilUmiditate) / 2}%"),
                          ItemPreference('assets/icons/sun.svg',
                              "${(widget.plant.lumina.minLumina + 100) / 2}%"),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(0.04 * widget.screenWidth),
                        child: AutoSizeText(
                          widget.plant.detaliiPlanta,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 13,
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

  Container ItemPreference(String pathImage, String text) {
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
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
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

  Widget _buildProgressIndicator(String label, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        LinearProgressIndicator(value: progress),
      ],
    );
  }
}
