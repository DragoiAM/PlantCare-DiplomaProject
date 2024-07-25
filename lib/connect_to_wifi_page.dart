import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'home_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:async';

Future<void> requestPermissions() async {
  await [Permission.location].request();
}

class ConnectToWiFi extends StatefulWidget {
  final String userId;
  final String plantId;
  final String lightId;
  final String airSensorsId;
  final String soilSensorsId;
  final String pumpId;
  ConnectToWiFi({
    Key? key,
    required this.userId,
    required this.plantId,
    required this.lightId,
    required this.airSensorsId,
    required this.soilSensorsId,
    required this.pumpId,
  }) : super(key: key);
  @override
  _ConnectToWiFiPageState createState() => _ConnectToWiFiPageState();
}

class _ConnectToWiFiPageState extends State<ConnectToWiFi> {
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedSSID;
  List<String> wifiList = [];
  bool _isPasswordVisible = false;
  @override
  void initState() {
    super.initState();
    getWifiList();
    _isPasswordVisible = false;
  }

  void getWifiList() async {
    try {
      List<WifiNetwork> wifiNetworks = await WiFiForIoTPlugin.loadWifiList();
      setState(() {
        wifiList = wifiNetworks
            .map((network) => network.ssid)
            .whereType<String>()
            .toList();
      });
    } catch (e) {
      print('Error fetching Wi-Fi list: $e');
    }
  }

  void _sendToESP32() async {
    _showLoadingDialog(); // Show loading dialog

    String ssid = _selectedSSID ?? '';
    String password = _passwordController.text;
    String url = 'http://192.168.1.106/setwifi';
    try {
      var response = await http.post(Uri.parse(url), body: {
        'ssid': ssid,
        'password': password
      }).timeout(Duration(seconds: 15)); // Add a timeout

      if (response.body.contains("Connected to WiFi")) {
        _sendDataESP32();
      } else {
        _showDialog("Response", response.body);
      }
    } catch (e) {
      Navigator.of(context).pop();

      _showDialog("Eroare",
          "Operațiunea a depășit limita de timp sau altă eroare de rețea.\nTrebuie sa te conectezi la adresa Wi-Fi a senzorilor!\n Datele de conectare sunt:\n SSID: PlantCareDevice\n Parola:123456789");
    }
  }

  void _sendDataESP32() async {
    String url = 'http://192.168.1.106/saveData';
    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'userId': widget.userId,
          'plantId': widget.plantId,
          'lightId': widget.lightId,
          'airSensorsId': widget.airSensorsId,
          'soilSensorsId': widget.soilSensorsId,
          'pumpId': widget.pumpId,
        },
      );
      Navigator.of(context).pop();
      if (response.body.contains("Data received successfully")) {
        _showDialogConnected();
      } else {
        _showDialog("Response", response.body);
      }
    } catch (e) {
      Navigator.of(context).pop();
      _showDialog("Error", "Data could not be transmitted");
    }
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(
                              userId: widget.userId,
                            )));
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Se conectează..."),
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
    return Scaffold(
      body: Center(
        child: Container(
          color: Theme.of(context).colorScheme.background,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              height: screenHeight * 0.5,
              width: screenWidth * 0.9,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: AutoSizeText(
                      'Conecteaza dispozitivul la internet',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      minFontSize: 20,
                      maxFontSize: 50,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child: DropdownButton<String>(
                        dropdownColor: Theme.of(context).colorScheme.secondary,
                        focusColor: Theme.of(context).colorScheme.secondary,
                        value: _selectedSSID,
                        hint: AutoSizeText(
                          "Selecteaza o retea",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          minFontSize: 15,
                          maxFontSize: 30,
                        ),
                        icon: Icon(
                          Icons.arrow_downward,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        underline: Container(
                          height: 2,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        items: wifiList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedSSID = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.01),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Parola WiFi',
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        fillColor: Theme.of(context).colorScheme.surface,
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      cursorColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.01),
                    child: AutoSizeText(
                      'Inainte de a asocia te rog sa verifici sa fii conectat la reteaua Wi-Fi a dispozitivului.',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      minFontSize: 15,
                      maxFontSize: 30,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            deletePlantData(widget.userId, widget.plantId);
                          },
                          child: Text(
                            'Anuleaza',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
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
                          onPressed: _sendToESP32,
                          child: Text(
                            'Asociaza senzorii cu planta',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> deletePlantData(String userId, String plantId) async {
    _showLoadingDialogAnulate(); // Show the loading dialog
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
      Navigator.of(context).pop();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(
            userId: widget.userId,
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      // Close the loading dialog even if there's an error
      Navigator.of(context).pop();
    }
  }

  void _showLoadingDialogAnulate() {
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
