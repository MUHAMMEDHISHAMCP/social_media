import 'package:flutter/material.dart';

import 'package:jsc_task2/screens/account_screen.dart';
import 'package:jsc_task2/screens/add_post_screen.dart';
import 'package:jsc_task2/screens/home_screen.dart';
import 'package:jsc_task2/utils/const_color.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<BottomNav> {
  int selectedIndex = 0;

  final screens = [
    const HomeScreen(),
    const AddPostScreen(),
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: subColor,
          unselectedItemColor: iconColor,
          backgroundColor: const Color(0xff134CB5),
          iconSize: 30,
          currentIndex: selectedIndex,
          onTap: (newIndex) {
            setState(() {
              selectedIndex = newIndex;
            });
          },
          items: const [
            BottomNavigationBarItem(
              backgroundColor: subColor,
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: subColor,
              icon: Icon(Icons.add_box_outlined),
              label: 'Add Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Account',
            )
          ]),
    );
  }
}
