import 'package:flutter/material.dart';

class MyButtonT extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  const MyButtonT({super.key, this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Color.fromARGB(255, 141, 101, 186),
      height: 54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: onPressed,
      child: Text(
        (title),
        style: TextStyle(
          fontSize: 20,
          color: Color.fromARGB(255, 238, 236, 240),
        ),
      ),
    );
  }
}
