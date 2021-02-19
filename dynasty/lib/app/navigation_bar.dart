import 'package:dynasty/app/home_page.dart';
import 'package:dynasty/app/profile_page.dart';
import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  List<BottomNavigationBarItem> _items;
  int _index = 0;
  final _pageOptions = [
    HomePage(),
    ProfilePage(),
  ];
  
  @override
  void initState() {
    _items = List();
    _items.add(BottomNavigationBarItem(
        icon: Icon(Icons.home), label: 'Home',));
    _items.add(BottomNavigationBarItem(
      icon: Icon(Icons.person), label: 'Profile',));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pageOptions[_index],
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        fixedColor: Colors.white,
        backgroundColor: Colors.green[500],
        currentIndex: _index,
        onTap: (int item) {
          setState(() {
            _index = item;
          });
        },
      ),
    );
  }
}
