import 'package:filmmap/pages/home_page.dart';
import 'package:filmmap/pages/home_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class RouterPage extends StatefulWidget {
  const RouterPage({super.key});

  @override
  State<RouterPage> createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
  int _selectedIndex = 0;

  final _pages = const [
    HomePage(),
    HomeTvShowPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: _pages[_selectedIndex],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.0),
              child: SalomonBottomBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                items: [
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.movie),
                    title: const Text("Filmler"),
                    selectedColor: Colors.white,
                    unselectedColor: Colors.grey,
                  ),
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.tv),
                    title: const Text("Diziler"),
                    selectedColor: Colors.white,
                    unselectedColor: Colors.grey,
                  ),
                ],
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
