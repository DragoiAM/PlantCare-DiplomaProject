import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class PlantUtils {
  static Future<void> fetchAndUpdatePlantSensorsData(String userId) async {
    // Reference to the user's plants collection in Firestore
    var userPlantsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Plante');

    // Fetch all plants for the user
    var plantsQuerySnapshot = await userPlantsRef.get();

    // Iterate over each plant document
    for (var plantDocSnapshot in plantsQuerySnapshot.docs) {
      // Fetch the latest Pump, Light, Air, and Soil data for each plant
      var dataPump = await plantDocSnapshot.reference
          .collection('Pompe')
          .get()
          .then(
              (snapshot) => snapshot.docs.first.data() as Map<String, dynamic>);
      var dataLightSensor = await plantDocSnapshot.reference
          .collection('SenzorLumina')
          .get()
          .then(
              (snapshot) => snapshot.docs.first.data() as Map<String, dynamic>);
      var dataAirSensor = await plantDocSnapshot.reference
          .collection('SenzoriAer')
          .get()
          .then(
              (snapshot) => snapshot.docs.first.data() as Map<String, dynamic>);
      var dataSoilSensor = await plantDocSnapshot.reference
          .collection('SenzoriSol')
          .get()
          .then(
              (snapshot) => snapshot.docs.first.data() as Map<String, dynamic>);

      // Prepare the updated data maps for each sensor
      Map<String, dynamic> pumpData = {
        'uda': dataPump['uda'],
        'ultima_udare': dataPump['ultima_udare'],
      };
      Map<String, dynamic> lightData = {
        'lumina': dataLightSensor['lumina'],
        'min_lumina': dataLightSensor['min_lumina'],
      };
      Map<String, dynamic> airData = {
        'senzor_temperatura': dataAirSensor['senzor_temperatura'],
        'senzor_umiditate': dataAirSensor['senzor_umiditate'],
      };
      Map<String, dynamic> soilData = {
        'senzor_temperatura': dataSoilSensor['senzor_temperatura'],
        'min_temperatura': dataSoilSensor['min_temperatura'],
        'max_temperatura': dataSoilSensor['max_temperatura'],
        'senzor_umiditate': dataSoilSensor['senzor_umiditate'],
        'min_umiditate': dataSoilSensor['min_umiditate'],
        'max_umiditate': dataSoilSensor['max_umiditate'],
      };

      // Update the plant document with the new sensor data
      await userPlantsRef.doc(plantDocSnapshot.id).update({
        'pompa': pumpData,
        'lumina': lightData,
        'aer': airData,
        'sol': soilData,
      }).catchError((error) {
        print("Error updating plant ${plantDocSnapshot.id}: $error");
      });
    }
  }

  // Reference to the Hive box for caching plant data
  static final Box _plantBox = Hive.box('plantBox');
  static Map<String, dynamic> safelyConvertMapKeysToString(
      Map<dynamic, dynamic> map) {
    return map.map((key, value) => MapEntry(key.toString(), value));
  }

  static Future<void> cachePlantsData(String userId, List<Plant> plants) async {
    // Serialize the list of Plant objects to a list of Maps
    List<Map<String, dynamic>> serializedPlants =
        plants.map((plant) => plant.toMap()).toList();

    // Store the serialized plant data in Hive under the given userId
    await _plantBox.put(userId, serializedPlants);
  }

  // Optionally, implement a method to retrieve cached data
  static Future<List<Plant>> retrieveCachedPlants(String userId) async {
    final cachedData = _plantBox.get(userId);
    if (cachedData != null) {
      List<Plant> cachedPlants = [];
      try {
        List<dynamic> dataList = List<dynamic>.from(cachedData);
        for (var plantData in dataList) {
          if (plantData is Map) {
            // Use the conversion method here
            Map<String, dynamic> properlyTypedMap =
                safelyConvertMapKeysToString(
                    plantData.cast<dynamic, dynamic>());
            cachedPlants.add(Plant.fromMap(properlyTypedMap));
          }
        }
      } catch (e) {
        print("Error processing cached data: $e");
      }
      return cachedPlants;
    } else {
      return [];
    }
  }

  static Future<void> updateCachedPlants(
      String userId, List<Plant> updatedPlants) async {
    // Serialize the updated list of Plant objects to a list of Maps
    List<Map<String, dynamic>> serializedPlants =
        updatedPlants.map((plant) => plant.toMap()).toList();

    // Overwrite the existing cached data with the updated list
    await _plantBox.put(userId, serializedPlants);
  }

  static Future<void> updateSinglePlantInCache(
      String userId, Plant updatedPlant) async {
    var cachedData = _plantBox.get(userId);
    if (cachedData != null) {
      List<Plant> cachedPlants = (cachedData as List)
          .map((plantMap) => Plant.fromMap(Map<String, dynamic>.from(plantMap)))
          .toList();

      // Find and replace the plant to be updated in the cachedPlants list
      int indexToUpdate = cachedPlants
          .indexWhere((plant) => plant.idPlanta == updatedPlant.idPlanta);
      if (indexToUpdate != -1) {
        cachedPlants[indexToUpdate] = updatedPlant; // Perform the update
        // Serialize and cache the updated list
        List<Map<String, dynamic>> serializedPlants =
            cachedPlants.map((plant) => plant.toMap()).toList();
        await _plantBox.put(userId, serializedPlants);
      }
    }
  }

// This method should be at the class level, not nested inside another method.
  /*static Future<File?> loadImageFromCache(String imageName) async {
    final Box _cacheBox = Hive.box('imageBox');
    final String? filePath = _cacheBox.get(imageName);
    print('Retrieved image path from cache: $filePath');

    if (filePath != null) {
      final File file = File(filePath);
      final exists = await file.exists();
      print('File exists: $exists');
      if (exists) return file;
    }
    return null;
  }*/

  /* static Future<void> cacheImage(String imageUrl, String imageName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$imageName';

    print('Downloading image: $imageUrl');
    final response = await http.get(Uri.parse(imageUrl));
    final file = File(filePath);

    await file.writeAsBytes(response.bodyBytes);
    print('Image downloaded and saved to: $filePath');
    final Box _cacheBox = Hive.box('imageBox');
    await _cacheBox.put(imageName, filePath);
    print('Image path saved in Hive box: $filePath');
  }*/
}

class Plant {
  String numePlanta;
  String imagine;
  String detaliiPlanta;
  String idPlanta;
  DateTime dataInregistrare;
  Pump pompa;
  Light lumina;
  Air aer;
  Soil sol;
  Plant(this.numePlanta, this.imagine, this.detaliiPlanta, this.idPlanta,
      this.dataInregistrare, this.pompa, this.lumina, this.aer, this.sol);

  static Future<List<Plant>> fetchByUserId(String userId) async {
    List<Plant> userPlants = [];
    try {
      // Navigate to the user's document, then to the 'Plante' subcollection
      var plantsQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('Plante')
          .get();

      for (var plantDocSnapshot in plantsQuerySnapshot.docs) {
        Map<String, dynamic> plantData =
            plantDocSnapshot.data() as Map<String, dynamic>;
        DateTime dataInregistrare =
            (plantData['data_inregistrare'] as Timestamp?)?.toDate() ??
                DateTime.now();
        var dataSoilSensor = await plantDocSnapshot.reference
            .collection('SenzoriSol')
            .get()
            .then((snapshot) =>
                snapshot.docs.first.data() as Map<String, dynamic>);
        var dataAirSensor = await plantDocSnapshot.reference
            .collection('SenzoriAer')
            .get()
            .then((snapshot) =>
                snapshot.docs.first.data() as Map<String, dynamic>);
        var dataPump = await plantDocSnapshot.reference
            .collection('Pompe')
            .get()
            .then((snapshot) =>
                snapshot.docs.first.data() as Map<String, dynamic>);
        // Fetch the document snapshot for pump data
        var pumpQuerySnapshot =
            await plantDocSnapshot.reference.collection('Pompe').get();

        if (pumpQuerySnapshot.docs.isNotEmpty) {
          var pumpData =
              pumpQuerySnapshot.docs.first.data() as Map<String, dynamic>;
          var pumpDocumentId = pumpQuerySnapshot.docs.first.id;

          // If 'uda' is true, then update 'ultima_udare' with current timestamp
          if (pumpData['uda'] == true) {
            await plantDocSnapshot.reference
                .collection('Pompe')
                .doc(pumpDocumentId) // Use the stored document ID here
                .update({
              'ultima_udare': Timestamp.now(),
            });

            // Also update the local variable to reflect this change
            pumpData['ultima_udare'] = Timestamp.now();
          }
        }

        var dataLightSensor = await plantDocSnapshot.reference
            .collection('SenzorLumina')
            .get()
            .then((snapshot) =>
                snapshot.docs.first.data() as Map<String, dynamic>);

        // Initialize Pump, Light, Air, and Soil objects using the methods
        Pump pompa = initializePump(dataPump);
        Light lumina = initializeLight(dataLightSensor);
        Air aer = initializeAir(dataAirSensor);
        Soil sol = initializeSoil(dataSoilSensor);
        // Create a new Plant object with the initialized objects and other plant data
        Plant plant = Plant(
          plantData['nume_planta'] ?? 'Unknown',
          plantData['image'] ?? '',
          plantData['detalii_planta'] ?? '',
          plantDocSnapshot
              .id, // This assumes each plant has a unique ID within its document
          dataInregistrare,
          pompa,
          lumina,
          aer,
          sol,
        );

        //String imageUrl = plantData['image'];
        //Extract the image name from the URL or create a unique name for the image
        //String imageName = 'plant_${plantDocSnapshot.id}';
        //await PlantUtils.cacheImage(imageUrl, imageName);

        // Add the newly created Plant object to the list
        userPlants.add(plant);
      }
    } catch (e) {
      print(e); // Handle the error or throw
    }
    return userPlants;
  }

  // Convert a Plant object to a Map
  Map<String, dynamic> toMap() {
    return {
      'numePlanta': numePlanta,
      'imagine': imagine,
      'detaliiPlanta': detaliiPlanta,
      'idPlanta': idPlanta,
      'dataInregistrare': dataInregistrare.toIso8601String(),
      // Assuming Pump, Light, Air, and Soil have their own toMap methods
      'pompa': pompa.toMap(),
      'lumina': lumina.toMap(),
      'aer': aer.toMap(),
      'sol': sol.toMap(),
    };
  }

  static Plant fromMap(Map<String, dynamic> map) {
    // Manually extract and convert each field
    String numePlanta = map['numePlanta'];
    String imagine = map['imagine'];
    String detaliiPlanta = map['detaliiPlanta'];
    String idPlanta = map['idPlanta'];
    DateTime dataInregistrare = DateTime.parse(map['dataInregistrare']);
    Map<String, dynamic> pumpMap = PlantUtils.safelyConvertMapKeysToString(
        map['pompa'] as Map<dynamic, dynamic>);
    Map<String, dynamic> lightMap = PlantUtils.safelyConvertMapKeysToString(
        map['lumina'] as Map<dynamic, dynamic>);
    Map<String, dynamic> airMap = PlantUtils.safelyConvertMapKeysToString(
        map['aer'] as Map<dynamic, dynamic>);
    Map<String, dynamic> soilMap = PlantUtils.safelyConvertMapKeysToString(
        map['sol'] as Map<dynamic, dynamic>);

    Pump pompa = Pump.fromMap(pumpMap);
    Light lumina = Light.fromMap(lightMap);
    Air aer = Air.fromMap(airMap);
    Soil sol = Soil.fromMap(soilMap);

    // Create and return a new Plant instance
    return Plant(numePlanta, imagine, detaliiPlanta, idPlanta, dataInregistrare,
        pompa, lumina, aer, sol);
  }

  static Future<void> updateAllPlantsForUser(
      String userId,
      Map<String, dynamic> pumpData,
      Map<String, dynamic> lightData,
      Map<String, dynamic> airData,
      Map<String, dynamic> soilData) async {
    var userPlantsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Plante');
    var plantsQuerySnapshot = await userPlantsRef.get();

    // Iterate over each plant document and update the fields
    for (var plantDocSnapshot in plantsQuerySnapshot.docs) {
      await userPlantsRef.doc(plantDocSnapshot.id).update({
        'pompa': pumpData,
        'lumina': lightData,
        'aer': airData,
        'sol': soilData,
      }).catchError((error) {
        print("Error updating plant ${plantDocSnapshot.id}: $error");
      });
    }
  }

  static Pump initializePump(Map<String, dynamic> data) {
    bool uda = data['uda'] ?? false;
    DateTime ultimaUdare =
        (data['ultima_udare'] as Timestamp?)?.toDate() ?? DateTime.now();
    return Pump(uda, ultimaUdare);
  }

  static Light initializeLight(Map<String, dynamic> data) {
    double lumina = data['lumina']?.toDouble() ?? 0.0;
    double minLumina = data['min_lumina']?.toDouble() ?? 0.0;
    return Light(lumina, minLumina);
  }

  static Air initializeAir(Map<String, dynamic> data) {
    double temperatura = data['senzor_temperatura']?.toDouble() ?? 0.0;
    double umiditate = data['senzor_umiditate']?.toDouble() ?? 0.0;
    return Air(temperatura, umiditate);
  }

  static Soil initializeSoil(Map<String, dynamic> data) {
    double soilTemperatura = data['senzor_temperatura']?.toDouble() ?? 0.0;
    double minSoilTemperatura = data['min_temperatura']?.toDouble() ?? 0.0;
    double maxSoilTemperatura = data['max_temperatura']?.toDouble() ?? 0.0;
    double soilUmiditate = data['senzor_umiditate']?.toDouble() ?? 0.0;
    double minSoilUmiditate = data['min_umiditate']?.toDouble() ?? 0.0;
    double maxSoilUmiditate = data['max_umiditate']?.toDouble() ?? 0.0;
    return Soil(
      soilTemperatura,
      minSoilTemperatura,
      maxSoilTemperatura,
      soilUmiditate,
      minSoilUmiditate,
      maxSoilUmiditate,
    );
  }
}

class Pump {
  bool uda;
  DateTime ultimaUdare;

  Pump(this.uda, this.ultimaUdare);
  Map<String, dynamic> toMap() {
    return {
      'uda': uda,
      'ultimaUdare': ultimaUdare.toIso8601String(),
    };
  }

  static Pump fromMap(Map<String, dynamic> map) {
    // Handle potential type inconsistency for 'uda'. Ensure it's a boolean.
    bool uda = map['uda'] is bool ? map['uda'] : (map['uda'] == 'true');

    // Safely parse 'ultimaUdare' to DateTime, with a fallback in case of failure.
    DateTime ultimaUdare;
    try {
      ultimaUdare = DateTime.parse(map['ultimaUdare']);
    } catch (e) {
      // Fallback to a default date or the current date if parsing fails.
      ultimaUdare = DateTime.now();
      // Log the error or handle it as necessary.
      print("Error parsing date: ${e.toString()}");
    }

    return Pump(uda, ultimaUdare);
  }
}

class Light {
  double lumina;
  double minLumina;
  Light(this.lumina, this.minLumina);
  // Convert a Light object to a Map
  Map<String, dynamic> toMap() {
    return {
      'lumina': lumina,
      'minLumina': minLumina,
    };
  }

  // Convert a Map to a Light object
  static Light fromMap(Map<String, dynamic> map) {
    // Ensure that 'lumina' is treated as a double, with a fallback if necessary.
    double lumina = 0.0;
    if (map['lumina'] != null) {
      lumina = map['lumina'] is double
          ? map['lumina']
          : double.tryParse(map['lumina'].toString()) ?? 0.0;
    }

    // Ensure that 'minLumina' is treated as a double, with a fallback if necessary.
    double minLumina = 0.0;
    if (map['minLumina'] != null) {
      minLumina = map['minLumina'] is double
          ? map['minLumina']
          : double.tryParse(map['minLumina'].toString()) ?? 0.0;
    }

    return Light(lumina, minLumina);
  }
}

class Air {
  double temperatura;
  double umiditate;

  Air(this.temperatura, this.umiditate);

  // Convert an Air object to a Map
  Map<String, dynamic> toMap() {
    return {
      'temperatura': temperatura,
      'umiditate': umiditate,
    };
  }

  // Convert a Map to an Air object
  static Air fromMap(Map<String, dynamic> map) {
    // Ensure that 'temperatura' is treated as a double, with a fallback if necessary.
    double temperatura = 0.0;
    if (map['temperatura'] != null) {
      temperatura = map['temperatura'] is double
          ? map['temperatura']
          : double.tryParse(map['temperatura'].toString()) ?? 0.0;
    }

    // Ensure that 'umiditate' is treated as a double, with a fallback if necessary.
    double umiditate = 0.0;
    if (map['umiditate'] != null) {
      umiditate = map['umiditate'] is double
          ? map['umiditate']
          : double.tryParse(map['umiditate'].toString()) ?? 0.0;
    }

    return Air(temperatura, umiditate);
  }
}

class Soil {
  double soilTemperatura;
  double minSoilTemperatura;
  double maxSoilTemperatura;
  double soilUmiditate;
  double minSoilUmiditate;
  double maxSoilUmiditate;

  Soil(this.soilTemperatura, this.minSoilTemperatura, this.maxSoilTemperatura,
      this.soilUmiditate, this.minSoilUmiditate, this.maxSoilUmiditate);

  // Convert a Soil object to a Map
  Map<String, dynamic> toMap() {
    return {
      'soilTemperatura': soilTemperatura,
      'minSoilTemperatura': minSoilTemperatura,
      'maxSoilTemperatura': maxSoilTemperatura,
      'soilUmiditate': soilUmiditate,
      'minSoilUmiditate': minSoilUmiditate,
      'maxSoilUmiditate': maxSoilUmiditate,
    };
  }

  // Convert a Map to a Soil object
  static Soil fromMap(Map<String, dynamic> map) {
    // Ensure that all temperature and humidity values are treated as doubles, with fallbacks if necessary.
    double soilTemperatura = map['soilTemperatura'] is double
        ? map['soilTemperatura']
        : double.tryParse(map['soilTemperatura']?.toString() ?? '0.0') ?? 0.0;
    double minSoilTemperatura = map['minSoilTemperatura'] is double
        ? map['minSoilTemperatura']
        : double.tryParse(map['minSoilTemperatura']?.toString() ?? '0.0') ??
            0.0;
    double maxSoilTemperatura = map['maxSoilTemperatura'] is double
        ? map['maxSoilTemperatura']
        : double.tryParse(map['maxSoilTemperatura']?.toString() ?? '0.0') ??
            0.0;
    double soilUmiditate = map['soilUmiditate'] is double
        ? map['soilUmiditate']
        : double.tryParse(map['soilUmiditate']?.toString() ?? '0.0') ?? 0.0;
    double minSoilUmiditate = map['minSoilUmiditate'] is double
        ? map['minSoilUmiditate']
        : double.tryParse(map['minSoilUmiditate']?.toString() ?? '0.0') ?? 0.0;
    double maxSoilUmiditate = map['maxSoilUmiditate'] is double
        ? map['maxSoilUmiditate']
        : double.tryParse(map['maxSoilUmiditate']?.toString() ?? '0.0') ?? 0.0;

    return Soil(
      soilTemperatura,
      minSoilTemperatura,
      maxSoilTemperatura,
      soilUmiditate,
      minSoilUmiditate,
      maxSoilUmiditate,
    );
  }
}
