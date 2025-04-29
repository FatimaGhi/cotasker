import 'package:flutter/material.dart';

mybottonnavigationbar(int selectedindex, onTap, String t) {
  return BottomNavigationBar(
      currentIndex: selectedindex,
      onTap: onTap,
      backgroundColor: Colors.purple,
      selectedItemColor: Colors.white,
      unselectedItemColor: Color.fromARGB(255, 6, 6, 7),
      selectedLabelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
          backgroundColor: Color.fromARGB(255, 141, 101, 186),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task),
          label: t, //le3ba hena hhh
          backgroundColor: Color.fromARGB(255, 141, 101, 186),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notification_add),
          label: "Notification",
          backgroundColor: Color.fromARGB(255, 141, 101, 186),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
          backgroundColor: Color.fromARGB(255, 141, 101, 186),
        ),
      ]);
}
//  setState(() {
//                   selectedindex = val;
//                   if (selectedindex == 1) {
//                     Navigator.of(context).pushNamed("MyProject");
//                   }
//                   if (selectedindex == 0) {
//                     Navigator.of(context).pushNamed("HomePage");
//                   }
//                 })