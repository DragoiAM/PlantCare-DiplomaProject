import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_project/Tools/plant_class.dart';
import 'package:test_project/Tools/plant_saved_class.dart';
import 'Components/nav_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_project/chat_page.dart';
import 'package:test_project/plant_info_widget.dart';
import '../camera.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  final String userId;

  const MyHomePage({
    super.key,
    required this.userId,
  });

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  double temperatura = 0.0;
  double umiditate = 0.0;
  Timer? _timer;
  List<Plant> plants = [];
  String first_name = "";
  String last_name = "";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _initPlants();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      var fetchedPlants =
          await Plant.fetchByUserId(widget.userId); // Fetch from Firestore
      await PlantUtils.cachePlantsData(widget.userId, fetchedPlants);
      await PlantSaved.fetchAndStorePlantsInHive(widget.userId);
      setState(() {
        // Ensure setState is used here to trigger UI updates
        plants = fetchedPlants;
      });
    });
  }

  void _initPlants() async {
    try {
      var fetchedPlants = await PlantUtils.retrieveCachedPlants(widget.userId);
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      first_name = userDoc.data()?['firstName'] ?? '';
      last_name = userDoc.data()?['lastName'] ?? '';
      if (fetchedPlants.isNotEmpty) {
        setState(() {
          plants = fetchedPlants;
        });
      } else {
        // Fallback: Fetch from Firestore and cache the data
        fetchedPlants = await Plant.fetchByUserId(widget.userId);
        if (fetchedPlants.isNotEmpty) {
          await PlantUtils.cachePlantsData(widget.userId, fetchedPlants);
          setState(() {
            plants = fetchedPlants;
          });
        } else {
          print('No plants found for user: ${widget.userId} in Firestore.');
        }
      }
    } catch (e) {
      print('Failed to load plants: $e');
    }
  }

  void _onScan() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CameraPage(
        userId: widget.userId,
      ),
    ));
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.onSurface,
        child: Center(
          child: _selectedIndex == 0
              ? PlantInfoWidget(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                  temperatura: temperatura,
                  umiditate: umiditate,
                  userId: widget.userId,
                  plants: plants,
                )
              : ChatPage(
                  userID: widget.userId,
                ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex != 1
          ? Transform.scale(
              scale: 1.5,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 10,
                onPressed: _onScan,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    'assets/icons/scanPlant.svg',
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
    );
  }
}
