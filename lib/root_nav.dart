import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'consult_doctor_screen.dart';
import 'profile_screen.dart';

class RootNav extends StatefulWidget {
  const RootNav({super.key});

  @override
  State<RootNav> createState() => _RootNavState();
}

class _RootNavState extends State<RootNav> {
  int _index = 0;

  final pages = const [
    HomeScreen(),
    ConsultDoctorScreen(),
    ProfileScreen(), // login + signup here
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (v) => setState(() => _index = v),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: "Home"),
          NavigationDestination(
              icon: Icon(Icons.medical_information_rounded),
              label: "Consult Doctor"),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}
