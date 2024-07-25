import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:test_project/Tools/plant_class.dart';
import '/Components/ProgresIndicatorWithSvg.dart';
import '../plant_page_info.dart';
import 'dart:async';
import '/../Tools/tools.dart';

class PlantInfoCard extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final String userId;
  final Plant plant;

  const PlantInfoCard({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.userId,
    required this.plant,
  });

  @override
  _PlantInfoCardState createState() => _PlantInfoCardState();
}

class _PlantInfoCardState extends State<PlantInfoCard> {
  String imagePath = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PlantPageInfo(
            screenWidth: widget.screenWidth,
            screenHeight: widget.screenHeight,
            userId: widget.userId,
            plant: widget.plant,
          ),
        ));
      },
      child: Container(
        width: widget.screenWidth,
        padding: EdgeInsets.all(widget.screenHeight / 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 0.015 * widget.screenHeight),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        'Temperatura aer',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        minFontSize: 5,
                        maxFontSize: 35,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                      AutoSizeText(
                        widget.plant.aer.temperatura.toString() + "°C",
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        minFontSize: 15,
                        maxFontSize: 45,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                  SizedBox(width: widget.screenWidth * 0.2),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        'Umiditate aer',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        minFontSize: 5,
                        maxFontSize: 35,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                      AutoSizeText(
                        widget.plant.aer.umiditate.toString() + "%",
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        minFontSize: 15,
                        maxFontSize: 45,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  )
                ],
              ),
              height: widget.screenHeight * 0.1,
              width: widget.screenWidth,
              padding: EdgeInsets.all(widget.screenHeight / 500),
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
            ),
            SizedBox(height: widget.screenHeight * 0.015),
            Container(
              height: widget.screenHeight * 0.61,
              width: widget.screenWidth,
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
                  Padding(
                    padding: EdgeInsets.all(widget.screenWidth * 0.04),
                    child: SizedBox(
                      height: widget.screenHeight * 0.3,
                      width: widget.screenWidth,
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
                          return Text('Eroare la incarcarea imaginii');
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: widget.screenHeight * 0.12,
                    width: widget.screenWidth * 0.6,
                    child: Column(
                      children: [
                        AutoSizeText(
                          widget.plant.numePlanta,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          minFontSize: 10,
                          maxFontSize: 40,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                        ),
                        AutoSizeText(
                          DateTime.now()
                                  .difference(widget.plant.dataInregistrare)
                                  .inDays
                                  .toString() +
                              ' zile monitorizate',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          minFontSize: 5,
                          maxFontSize: 25,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.clip,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: widget.screenHeight * 0.13,
                    width: widget.screenWidth * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProgressIndicatorWithSvg(
                          screenWidth: widget.screenWidth,
                          screenHeight: widget.screenHeight,
                          progress: Tools.percentCalculator(
                              widget.plant.sol.soilUmiditate,
                              widget.plant.sol.minSoilUmiditate,
                              widget.plant.sol.maxSoilUmiditate),
                          text: "${widget.plant.sol.soilUmiditate.round()}%",
                          assetPath: 'assets/icons/drop.svg',
                        ),
                        ProgressIndicatorWithSvg(
                          screenWidth: widget.screenWidth,
                          screenHeight: widget.screenHeight,
                          progress: Tools.percentCalculator(
                              widget.plant.lumina.lumina,
                              widget.plant.lumina.minLumina,
                              100),
                          text: "${widget.plant.lumina.lumina.round()}%",
                          assetPath: 'assets/icons/sun.svg',
                        ),
                        ProgressIndicatorWithSvg(
                          screenWidth: widget.screenWidth,
                          screenHeight: widget.screenHeight,
                          progress: Tools.percentCalculator(
                              widget.plant.sol.soilTemperatura,
                              widget.plant.sol.minSoilTemperatura,
                              widget.plant.sol.maxSoilTemperatura),
                          text: "${widget.plant.sol.soilTemperatura.round()}°C",
                          assetPath: 'assets/icons/temperature.svg',
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
