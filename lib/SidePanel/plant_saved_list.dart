import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:test_project/SidePanel/plant_save_item_page.dart';
import 'package:test_project/Tools/plant_saved_class.dart';

class PlantSavedList extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final String userId;

  PlantSavedList({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.userId,
  }) : super(key: key);

  @override
  _PlantSavedListState createState() => _PlantSavedListState();
}

class _PlantSavedListState extends State<PlantSavedList> {
  List<dynamic> _plants = []; // A list to store the plant data

  @override
  void initState() {
    super.initState();
    PlantSaved.fetchAndStorePlantsInHive(widget.userId);
    _fetchPlants(); // Fetch the plants when the widget is initialized
  }

  Future<void> _fetchPlants() async {
    var box = Hive.box('plantSavedBox');
    var plants = box.values.toList(); // Fetch all the plants saved in the box

    setState(() {
      _plants = plants; // Update the state with the fetched plants
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plante Salvate"),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: ListView.builder(
          itemCount: _plants.length, // Number of items in the list
          itemBuilder: (context, index) {
            var plant = _plants[index];
            return Padding(
              padding: EdgeInsets.only(
                  left: widget.screenWidth * 0.04,
                  right: widget.screenWidth * 0.04,
                  top: widget.screenWidth * 0.02,
                  bottom: widget.screenWidth * 0.02),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SavedPlantInfoPage(
                                      imagePath: plant['imageUrl'],
                                      plantName: plant['plantName'],
                                      plantInfo: plant['plantInfo'],
                                      temperature: plant['temperature'],
                                      humidity: plant['humidity'],
                                      sunlight: plant['sunlight'],
                                      screenWidth: widget.screenWidth,
                                      screenHeight: widget.screenHeight,
                                    )),
                          );
                        },
                        child: Container(
                          width: widget.screenWidth * 0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                plant['plantName'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                minFontSize: 10,
                                maxFontSize: 30,
                              ),
                              SizedBox(
                                height: widget.screenHeight * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _itemPreference(
                                      'assets/icons/temperature.svg',
                                      plant['temperature'] + "°C",
                                      context),
                                  _itemPreference('assets/icons/drop.svg',
                                      plant['humidity'] + "%", context),
                                  _itemPreference('assets/icons/sun.svg',
                                      plant['sunlight'], context),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(widget.screenWidth * 0.02),
                            child: SizedBox(
                              height: widget.screenHeight * 0.1,
                              width: widget.screenHeight * 0.1,
                              child: Image.network(
                                plant['imageUrl'].toString(),
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null)
                                    return child; // Image is fully loaded
                                  return Center(
                                    // Show loading indicator while image is loading
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
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
                                _deletePlant(plant['plantId']
                                    .toString()); // Call _deletePlant method when tapped
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize
                                    .min, // This makes the Row only as wide as its children
                                children: <Widget>[
                                  Icon(Icons.delete,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onError),
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
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _deletePlant(String plantId) async {
    _showLoadingDialog(); // Assuming this method shows a loading indicator to the user

    String userId =
        widget.userId; // Assuming `this.userId` holds the current user's ID
    CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');

    try {
      // Reference to the specific plant document in Firestore
      DocumentReference plantRef =
          usersRef.doc(userId).collection('PlantSaved').doc(plantId);

      // Delete the plant document from Firestore

      // Delete the plant image from Firebase Storage, if it exists
      var plantData =
          await plantRef.get(); // Get the plant document to access the imageUrl
      // First, safely access the plant data
      var data = plantData.data();

      if (plantData.exists &&
          (data as Map<String, dynamic>).containsKey('imageUrl')) {
        String? imageUrl = data['imageUrl'];

        // Proceed only if 'imageUrl' is not null
        if (imageUrl != null) {
          Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
          await imageRef.delete();
        }
        if (data.containsKey('plantName')) {
          String plantNameKey = 'isSaved_${data['plantName']}';
          var boxS = Hive.box('plantSavedBoxScanned');
          if (await boxS.containsKey(plantNameKey)) {
            await boxS.delete(
                plantNameKey); // Ensure this matches the key used when storing
          } else {
            print("Key not found in plantSavedBoxScanned: $plantNameKey");
          }
        }
        await plantRef.delete();
      }

      // Delete the plant data from the local Hive box
      var box = Hive.box('plantSavedBox');
      await box.delete(plantId);

      await _fetchPlants();

      Navigator.of(context).pop();
    } catch (e) {
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
        left: 0.04 * widget.screenWidth,
        right: 0.04 * widget.screenWidth,
        top: 0.01 * widget.screenWidth,
        bottom: 0.01 * widget.screenWidth,
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
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            minFontSize: 15,
            maxFontSize: 25,
            textAlign: TextAlign.center,
            overflow: TextOverflow.clip,
          ),
        ],
      ),
    );
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
