import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';

class PlantSaved {
  final String userId;
  final String plantName;
  final String plantInfo;
  final String temperature;
  final String humidity;
  final String sunlight;
  final String imagePath; // Add this field to hold the image path

  PlantSaved({
    required this.userId,
    required this.plantName,
    required this.plantInfo,
    required this.temperature,
    required this.humidity,
    required this.sunlight,
    required this.imagePath, // Initialize in the constructor
  });

  Future<String> _uploadImage(String imagePath, String storagePath) async {
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

  Future<void> save() async {
    String storagePath =
        'plant_images/$userId/${Uri.file(imagePath).pathSegments.last}';
    String? imageUrl =
        await _uploadImage(imagePath, storagePath); // Upload image and get URL

    // Only proceed if the image upload was successful

    // Generate a new document ID
    String plantId = FirebaseFirestore.instance.collection('plants').doc().id;

    Map<String, dynamic> plantData = {
      'plantId': plantId,
      'plantName': plantName,
      'plantInfo': plantInfo,
      'temperature': temperature,
      'humidity': humidity,
      'sunlight': sunlight,
      'imageUrl': imageUrl,
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('PlantSaved')
        .doc(plantId)
        .set(plantData)
        .catchError((error) {
      print("Failed to save plant: $error");
    });
  }

  Future<void> fetchAndStorePlants(String userId) async {
    var box = Hive.box('plantSavedBox');

    // Fetch the plants from Firestore
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('PlantSaved')
        .get();

    // Iterate through the documents and store them in Hive
    for (var document in snapshot.docs) {
      var plantData = document.data();
      // Use the document ID as the key for easy retrieval
      await box.put(document.id, plantData);
    }
  }

  static Future<void> fetchAndStorePlantsInHive(String userId) async {
    var box = Hive.box('plantSavedBox');
    var boxS = Hive.box('plantSavedBoxScanned');

    // Fetch the plants from Firestore
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('PlantSaved')
        .get();

    // Iterate through the documents and store them in Hive
    for (var document in snapshot.docs) {
      var plantData = document.data();
      await boxS.put('isSaved_${plantData['plantName']}', true);
      await box.put(document.id, plantData);
    }
  }
}
