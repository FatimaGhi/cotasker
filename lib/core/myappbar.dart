// import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

myappbar(String Title, BuildContext context) {
  return AppBar(
    title: Text(Title),
    actions: [
      IconButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context)
                .pushNamedAndRemoveUntil("/signin", (route) => false);
          },
          icon: Icon(Icons.exit_to_app))
    ],
    titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 120, 20, 138)),
    elevation: 20.0,
    shadowColor: const Color.fromARGB(255, 148, 77, 161),
    backgroundColor: const Color.fromARGB(255, 194, 191, 191),
  );
}
