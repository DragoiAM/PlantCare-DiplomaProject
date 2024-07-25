import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_project/SidePanel/account_info.dart';
import 'package:test_project/SidePanel/care.dart';
import 'package:test_project/SidePanel/plant_list.dart';
import 'package:test_project/SidePanel/plant_saved_list.dart';
import 'package:test_project/SidePanel/settings.dart';
import 'package:test_project/Tools/plant_class.dart';

class SidePannel extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final String userId;
  final List<Plant> plants;

  SidePannel({
    required this.screenHeight,
    required this.screenWidth,
    required this.userId,
    required this.plants,
  });
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border(
            right: BorderSide(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface, // Color for the vertical line
              width: 1.5, // Thickness of the vertical line
            ),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    'Plant Care',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    minFontSize: 25,
                    maxFontSize: 65,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  AutoSizeText(
                    'MENIU',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    minFontSize: 25,
                    maxFontSize: 65,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/icons/user-solid.svg',
                width: 25,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: AutoSizeText(
                'Informatii cont',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 25,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                minFontSize: 10,
                maxFontSize: 40,
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AccountInfoPage(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          userId: userId,
                        )));
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/icons/plant.svg',
                width: 25,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: AutoSizeText(
                'Plante monitorizate',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 25,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                minFontSize: 10,
                maxFontSize: 40,
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PlantList(
                          plants: plants,
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          userId: userId,
                        )));
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/icons/newPlant.svg',
                width: 25,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: AutoSizeText(
                'Plante salvate',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 25,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                minFontSize: 10,
                maxFontSize: 40,
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PlantSavedList(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          userId: userId,
                        )));
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/icons/info.svg',
                width: 25,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: AutoSizeText(
                'Ingrijire',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 25,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                minFontSize: 10,
                maxFontSize: 40,
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CarePage(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                        )));
              },
            ),
            ListTile(
              leading: SvgPicture.asset(
                'assets/icons/settings.svg',
                width: 25,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: AutoSizeText(
                'Setari',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 25,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                minFontSize: 10,
                maxFontSize: 40,
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.clip,
              ),
              onTap: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SettingsPage(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                        )));
              },
            ),
          ],
        ),
      ),
    );
  }
}
