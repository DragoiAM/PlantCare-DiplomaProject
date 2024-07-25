import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test_project/Components/ProgresIndicatorWithSvg.dart';
import 'package:test_project/Tools/plant_class.dart'; // Ensure this import is correct and points to your Plant class definition
import 'package:test_project/Tools/tools.dart';

class PlantList extends StatefulWidget {
  final List<Plant> plants;
  final double screenWidth;
  final double screenHeight;
  final String userId;
  PlantList({
    Key? key,
    required this.plants,
    required this.screenWidth,
    required this.screenHeight,
    required this.userId,
  }) : super(key: key);

  @override
  _PlantListState createState() => _PlantListState();
}

class _PlantListState extends State<PlantList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plante Monitorizatte"),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: ListView.builder(
          itemCount: widget.plants.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: widget.screenHeight * 0.01,
                          right: widget.screenHeight * 0.02),
                      child: Container(
                        width: widget.screenWidth * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              widget.plants[index].numePlanta,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              minFontSize: 10,
                              maxFontSize: 30,
                            ),
                            Container(
                              height: widget.screenHeight * 0.115,
                              width: widget.screenWidth * 0.5,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ProgressIndicatorWithSvg(
                                    screenWidth: widget.screenWidth,
                                    screenHeight: widget.screenHeight,
                                    progress: Tools.percentCalculator(
                                        widget.plants[index].sol.soilUmiditate,
                                        widget
                                            .plants[index].sol.minSoilUmiditate,
                                        widget.plants[index].sol
                                            .maxSoilUmiditate),
                                    text:
                                        "${widget.plants[index].sol.soilUmiditate.round()}%",
                                    assetPath: 'assets/icons/drop.svg',
                                  ),
                                  ProgressIndicatorWithSvg(
                                    screenWidth: widget.screenWidth,
                                    screenHeight: widget.screenHeight,
                                    progress: Tools.percentCalculator(
                                        widget.plants[index].lumina.lumina,
                                        widget.plants[index].lumina.minLumina,
                                        100),
                                    text:
                                        "${widget.plants[index].lumina.lumina.round()}%",
                                    assetPath: 'assets/icons/sun.svg',
                                  ),
                                  ProgressIndicatorWithSvg(
                                    screenWidth: widget.screenWidth,
                                    screenHeight: widget.screenHeight,
                                    progress: Tools.percentCalculator(
                                        widget
                                            .plants[index].sol.soilTemperatura,
                                        widget.plants[index].sol
                                            .minSoilTemperatura,
                                        widget.plants[index].sol
                                            .maxSoilTemperatura),
                                    text:
                                        "${widget.plants[index].sol.soilTemperatura.round()}°C",
                                    assetPath: 'assets/icons/temperature.svg',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(widget.screenWidth * 0.02),
                          child: SizedBox(
                            height: widget.screenHeight * 0.1,
                            width: widget.screenHeight * 0.1,
                            child: Image.network(
                              widget.plants[index].imagine.toString(),
                              fit: BoxFit.cover,
                              // Remove the initial CircularProgressIndicator from the Stack.
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null)
                                  return child; // Image is fully loaded
                                return Center(
                                  // Show loading indicator while image is loading
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                // Optionally handle errors, such as when the image cannot be loaded
                                return Text('Eroare la incarcarea imaginii');
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(widget.screenWidth * 0.01),
                          child: InkWell(
                            onTap: () {
                              _deletePlant(
                                  index); // Call _deletePlant method when tapped
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize
                                  .min, // This makes the Row only as wide as its children
                              children: <Widget>[
                                Icon(Icons.delete,
                                    color:
                                        Theme.of(context).colorScheme.onError),
                                Text("DELETE",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onError)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _deletePlant(int index) async {
    _showLoadingDialog(); // Show the loading dialog

    String plantId = widget.plants[index].idPlanta;
    String userId =
        widget.userId; // Assuming each Plant has a unique 'id' field
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');

    try {
      // Create a reference to the specific plant document
      DocumentReference plantRef =
          usersRef.doc(userId).collection('Plante').doc(plantId);

      // Get all subcollections of the plant
      List<CollectionReference> subcollections = [
        plantRef.collection('Pompe'),
        plantRef.collection('SenzorLumina'),
        plantRef.collection('SenzoriAer'),
        plantRef.collection('SenzoriSol'),
        // Add other subcollections if any
      ];

      // Delete all documents in each subcollection
      for (var subcollection in subcollections) {
        // Retrieve all documents in the subcollection
        QuerySnapshot querySnapshot = await subcollection.get();

        for (var doc in querySnapshot.docs) {
          await doc.reference.delete(); // Delete each document
        }
      }

      // Once all subcollections documents are deleted, delete the plant document itself
      await plantRef.delete();

      // After deletion, close the loading dialog
      Navigator.of(context).pop();

      // Update the local UI list
      setState(() {
        widget.plants.removeAt(index);
      });
    } catch (e) {
      // Close the loading dialog even if there's an error
      Navigator.of(context).pop();

      // Handle errors, e.g., show a Snackbar with an error message
      print("Error deleting plant: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Eroare la ștergerea plantei')), // "Error deleting plant"
      );
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
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
                AutoSizeText(
                  "Se anuleaza...",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  minFontSize: 20,
                  maxFontSize: 30,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
