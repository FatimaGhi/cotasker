import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key, required this.Title});
  final String Title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(Title),
      titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 120, 20, 138)),
      elevation: 20.0,
      shadowColor: const Color.fromARGB(255, 148, 77, 161),
      backgroundColor: const Color.fromARGB(255, 194, 191, 191),
    );
  }
}
