import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:test_project/Tools/plant_class.dart';

class Tools {
  static double percentCalculator(
      double currentValue, double minValue, double maxValue) {
    if (currentValue > maxValue) {
      return 100;
    }
    if (currentValue < minValue) {
      return 0;
    }
    if (minValue > maxValue) {
      double aux = minValue;
      minValue = maxValue;
      maxValue = aux;
    }

    double percent = (currentValue - minValue) * 100 / (maxValue - minValue);

    return percent;
  }

  static double parseToDouble(String input, {double defaultValue = 0.0}) {
    try {
      // Replace commas with dots if necessary (for locales that use commas as decimal points)
      final normalizedInput = input.replaceAll(',', '.');
      final result = double.parse(normalizedInput);
      return result;
    } catch (e) {
      // Log error or handle it accordingly
      print("Error parsing double: $e");
      // Return a default value in case of error
      return defaultValue;
    }
  }

  static Future<void> clearHiveBoxes() async {
    final boxes = await Hive.openBox('plantBox');
    await boxes.clear(); // Clear the 'plantBox' box

    final imageBox = await Hive.openBox('imageBox');
    await imageBox.clear(); // Clear the 'imageBox' box

    final plantSavedBox = await Hive.openBox('plantSavedBox');
    await plantSavedBox.clear(); // Clear the 'plantSavedBox' box

    final plantSavedBoxScanned = await Hive.openBox('plantSavedBoxScanned');
    await plantSavedBoxScanned.clear(); // Clear the 'plantSavedBox' box
  }

  static Future<void> signOut() async {
    await clearHiveBoxes();
    await FirebaseAuth.instance.signOut(); // Sign out from Firebase
  }

  static Future<void> fetchAndCacheUserPlants(String userId) async {
    try {
      List<Plant> plants =
          await Plant.fetchByUserId(userId); // Fetch from Firestore
      await PlantUtils.cachePlantsData(
          userId, plants); // Cache the fetched data
      // Handle the fetched data (e.g., update UI)
    } catch (e) {
      // Handle errors (e.g., network issues, Firebase errors)
    }
  }

  static String removeNonAlphabeticCharacters(String input) {
    RegExp nonAlphabeticExceptSpacePattern = RegExp(r'[^a-zA-Z ]');
    String result = input.replaceAll(nonAlphabeticExceptSpacePattern, '');

    return result;
  }
}
