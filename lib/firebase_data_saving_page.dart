import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_project/Tools/plant_class.dart';

import 'package:test_project/connect_to_wifi_page.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

Future<void> requestPermissions() async {
  await [Permission.location].request();
}

class FirebaseDataSavingPage extends StatefulWidget {
  final String imagePath;
  final String plantNameG;
  final String detaliiPlanta;
  final double max_temperatura;
  final double min_temperatura;
  final double max_umiditate;
  final double min_umiditate;
  final double min_luminozitate;
  final String userId;

  FirebaseDataSavingPage(
      {Key? key,
      required this.imagePath,
      required this.plantNameG,
      required this.detaliiPlanta,
      required this.max_temperatura,
      required this.min_temperatura,
      required this.max_umiditate,
      required this.min_umiditate,
      required this.min_luminozitate,
      required this.userId})
      : super(key: key);
  @override
  _ConnectToWiFiPageState createState() => _ConnectToWiFiPageState();
}

class _ConnectToWiFiPageState extends State<FirebaseDataSavingPage> {
  Map<String, String>? ids;
  @override
  void initState() {
    super.initState();
  }

  Future<void> addAndCachePlantData(
      String userId,
      String plantName,
      String detaliiPlanta,
      DateTime registrationDate,
      Map<String, dynamic> senzoriAerData,
      Map<String, dynamic> senzoriSolData,
      Map<String, dynamic> pompaData,
      Map<String, dynamic> senzoriLuminaData,
      String imagePath) async {
    // First, add the plant data to Firestore as before
    ids = await addPlantData(
        userId,
        plantName,
        detaliiPlanta,
        registrationDate,
        senzoriAerData,
        senzoriSolData,
        pompaData,
        senzoriLuminaData,
        imagePath);

    // Then, fetch the updated list of plants for this user from Firestore
    List<Plant> updatedPlants = await Plant.fetchByUserId(widget.userId);

    // Finally, update the cached plants data in Hive
    await PlantUtils.updateCachedPlants(widget.userId, updatedPlants);
  }

  Future<String> uploadImage(String imagePath, String storagePath) async {
    File file = File(imagePath);
    if (!file.existsSync()) {
      throw Exception("File does not exist at path: $imagePath");
    }
    try {
      // Create a reference to the location you want to upload to in Firebase Storage
      Reference ref = FirebaseStorage.instance.ref(storagePath);

      // Upload the file to Firebase Storage
      UploadTask uploadTask = ref.putFile(file);

      // Wait for the upload to complete
      await uploadTask;

      // Get the download URL
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Error uploading image: $e');
    }
  }

  Future<Map<String, String>> addPlantData(
      String userId,
      String plantName,
      String datePlanta,
      DateTime registrationDate,
      Map<String, dynamic> senzoriAerData,
      Map<String, dynamic> senzoriSolData,
      Map<String, dynamic> pompaData,
      Map<String, dynamic> senzoriLuminaData,
      String imagePath) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Upload the image first and get the download URL
    String storagePath =
        'plant_images/$userId/${Uri.file(imagePath).pathSegments.last}';
    String imageUrl = await uploadImage(imagePath, storagePath);

    // Reference to the User's document
    DocumentReference userDoc = firestore.collection('users').doc(userId);

    // Create a new Plant document inside the User's 'Plante' subcollection
    DocumentReference plantDoc = userDoc.collection('Plante').doc();

    // Start a batch write to perform all operations atomically
    WriteBatch batch = firestore.batch();

    // Set the Plant document data including imageUrl
    batch.set(plantDoc, {
      'id_utilizator':
          userId, // Assuming userId is a string here; convert if necessary
      'nume_planta': plantName,
      'data_inregistrare': Timestamp.fromDate(registrationDate),
      'detalii_planta': datePlanta,
      'image': imageUrl, // Store the image URL
    });

    // Add a new document to the SenzoriAer subcollection
    DocumentReference senzoriAerDoc = plantDoc.collection('SenzoriAer').doc();
    batch.set(senzoriAerDoc, senzoriAerData);

    // Add a new document to the SenzoriSol subcollection
    DocumentReference senzoriSolDoc = plantDoc.collection('SenzoriSol').doc();
    batch.set(senzoriSolDoc, senzoriSolData);

    // Add a new document to the Pompe subcollection
    DocumentReference pompaDoc = plantDoc.collection('Pompe').doc();
    batch.set(pompaDoc, pompaData);

    DocumentReference luminaDoc = plantDoc.collection('SenzorLumina').doc();
    batch.set(luminaDoc, senzoriLuminaData);
    Map<String, String> ids = {};
    // Commit the batch write to the database
    await batch.commit().then((_) {
      ids = {
        'plantId': plantDoc.id,
        'lightId': luminaDoc.id,
        'airSensorsId': senzoriAerDoc.id,
        'soilSensorsId': senzoriSolDoc.id,
        'pumpId': pompaDoc.id,
      };
      print('All plant data added successfully');
      _showDialogConnected();
    }).catchError((error) {
      print('Error writing plant data: $error');
      throw Exception('Failed to add plant data');
    });

    return ids; // Return the map containing the IDs
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Center(child: Text(title)),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(
                "OK",
                style: TextStyle(
                  decoration: TextDecoration.none,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogConnected() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          content: Container(
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
            height: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/check.svg',
                  width: 150,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Salvat cu succes!",
                  style: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.none,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Center(
                child: Text(
                  "OK",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConnectToWiFi(
                      userId: widget.userId,
                      plantId: ids!['plantId']!,
                      lightId: ids!['lightId']!,
                      airSensorsId: ids!['airSensorsId']!,
                      soilSensorsId: ids!['soilSensorsId']!,
                      pumpId: ids!['pumpId']!,
                    ),
                  ),
                  (Route<dynamic> route) =>
                      false, // This predicate will always return false, removing all routes below the new route
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showLoadingDialog() {
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
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      child: Container(
        height: screenHeight * 0.3,
        width: screenWidth * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            height: screenHeight * 0.2,
            width: screenWidth * 0.7,
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
              children: <Widget>[
                AutoSizeText(
                  'Ești sigur că vrei să salvezi?',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 25, // This is the maximum font size

                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  minFontSize: 20,
                  maxFontSize: 50,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                ),
                AutoSizeText(
                  'În următorul pas va trebui să asociezi planta cu dispozitivul de monitorizare.',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 15, // This is the maximum font size

                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  minFontSize: 10,
                  maxFontSize: 20,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                ),
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: AutoSizeText(
                          'Anulează',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          minFontSize: 10,
                          maxFontSize: 20,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          backgroundColor:
                              Theme.of(context).colorScheme.onError,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5.0,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _showLoadingDialog();
                          addAndCachePlantData(
                            widget.userId, // The User ID
                            widget.plantNameG, // Plant Name
                            widget.detaliiPlanta,
                            DateTime.now(), // Registration Date
                            {
                              // SenzoriAer data
                              'senzor_temperatura': 0,
                              'senzor_umiditate': 0
                            },
                            {
                              // SenzoriSol data
                              'senzor_temperatura': 0,
                              'senzor_umiditate': 0,
                              'max_temperatura': widget.max_temperatura,
                              'min_temperatura': widget.min_temperatura,
                              'max_umiditate': widget.max_umiditate,
                              'min_umiditate': widget.min_umiditate
                            },
                            {
                              // Pompa data
                              'ultima_udare': Timestamp.now(),
                              'uda': false
                            },
                            {
                              // Lumina data
                              'min_lumina': widget.min_luminozitate,
                              'lumina': 0
                            },
                            widget.imagePath,
                          ).then((_) {
                            // Handle success, such as by navigating back or showing a success message.
                          }).catchError((error) {
                            // Handle errors, such as by showing an error message.
                            print(
                                "Error adding and caching plant data: $error");
                          });
                        },
                        child: AutoSizeText(
                          'Salvează',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          minFontSize: 10,
                          maxFontSize: 20,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5.0,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
