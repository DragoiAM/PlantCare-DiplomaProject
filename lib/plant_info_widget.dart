import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_project/Components/PlantInfoCard.dart';
import 'package:test_project/SidePanel/side_panel.dart';
import 'Tools/plant_class.dart';

class PlantInfoWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final double temperatura;
  final double umiditate;
  final String userId;
  final List<Plant> plants;

  PlantInfoWidget({
    required this.screenHeight,
    required this.screenWidth,
    required this.temperatura,
    required this.umiditate,
    required this.userId,
    required this.plants,
  });

  @override
  _PlantInfoWidgetState createState() => _PlantInfoWidgetState();
}

// Define the corresponding State class
class _PlantInfoWidgetState extends State<PlantInfoWidget> {
  List<String> plantIds = [];
  String firstName = '';

  @override
  void initState() {
    super.initState();
    fetchFirstName(widget.userId).then((name) {
      if (mounted && name != 'No name found') {
        setState(() {
          firstName = name;
        });
      }
    }).catchError((error) {});
  }

  Future<String> fetchFirstName(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot userDoc =
        await firestore.collection('users').doc(userId).get();

    if (userDoc.exists) {
      final data =
          userDoc.data() as Map<String, dynamic>?; // Explicit cast to Map
      if (data != null && data.containsKey('firstName')) {
        return data['firstName'] ?? 'No name found';
      }
    }
    return 'No name found';
  }

  // Define a list to hold plant IDs

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight +
            (widget.screenWidth * 0.05)), // Adjust the height accordingly
        child: SafeArea(
          // Ensures the content is within the safe area of the screen
          child: Padding(
            padding: EdgeInsets.only(
              top: widget.screenWidth * 0.05,
              left: widget.screenWidth * 0.05,
              right: widget.screenWidth * 0.05,
            ),
            child: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Plantele tale,',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 30, // This is the maximum font size
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    minFontSize: 20,
                    maxFontSize: 50,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  AutoSizeText(
                    firstName,
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 15, // This is the maximum font size
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    minFontSize: 5,
                    maxFontSize: 30,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.background,
              elevation:
                  0, // Optional: Remove shadow if it doesn't fit your design
              leading: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer(); // Opens the drawer
                    },
                    child: SvgPicture.asset(
                      'assets/icons/menue.svg',
                      width: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(5),
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .secondary, // Your desired color
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: SidePannel(
        screenHeight: widget.screenHeight,
        screenWidth: widget.screenWidth,
        userId: widget.userId,
        plants: widget.plants,
      ),
      body: Container(
        padding: EdgeInsets.only(
            left: widget.screenWidth * 0.05, right: widget.screenWidth * 0.05),
        height: widget.screenHeight,
        width: widget.screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                widget.plants.isNotEmpty
                    ? Container(
                        height: widget.screenHeight * 0.8,
                        child: PageView.builder(
                          itemCount: widget.plants.length,
                          itemBuilder: (context, index) {
                            return PlantInfoCard(
                              screenWidth: widget.screenWidth,
                              screenHeight: widget.screenHeight,
                              userId: widget.userId,
                              plant: widget.plants[index],
                            );
                          },
                        ),
                      )
                    : Container(
                        height: widget.screenHeight * 0.7,
                        alignment: Alignment.center,
                        child: Text("Explorează colecția ta de plante aici."),
                      ),
              ],
            ),
            SizedBox(height: widget.screenHeight * 0.05),
          ],
        ),
      ),
    );
  }

  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}
