import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomNavBar extends StatelessWidget {
  final int? selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavBar({
    super.key,
    this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    bool isItemSelected = selectedIndex != null;

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/home.svg',
            width: 35,
            color: isItemSelected && selectedIndex == 0
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primary,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/chat.svg',
            width: 35,
            color: isItemSelected && selectedIndex == 1
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.primary,
          ),
          label: 'Intreaba IA',
        ),
      ],
      currentIndex: isItemSelected ? selectedIndex! : 0,
      selectedItemColor: Theme.of(context).colorScheme.onPrimary,
      unselectedItemColor: Theme.of(context).colorScheme.primary,
      onTap: onItemTapped,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      selectedLabelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      unselectedLabelStyle: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
      showUnselectedLabels: true,
      showSelectedLabels: true,
    );
  }
}
