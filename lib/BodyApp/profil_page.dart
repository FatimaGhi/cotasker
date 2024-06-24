import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotasker/core/myappbar.dart';
import 'package:cotasker/core/mybottonnavigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profil_page extends StatefulWidget {
  const Profil_page({super.key});

  @override
  State<Profil_page> createState() => _Profil_pageState();
}

class _Profil_pageState extends State<Profil_page> {
  int selectedindex = 3;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: myappbar("MyProfil", context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // CircleAvatar(
              //   radius: 70,
              //   backgroundImage: AssetImage('assets/images/user.JPG'),
              // ),
              const SizedBox(height: 20),
              itemProfile('Frist Name', 'fatima ', CupertinoIcons.person),
              const SizedBox(height: 10),
              itemProfile('last Name', 'Ahad Hashmi', CupertinoIcons.person),
              const SizedBox(height: 10),
              itemProfile('Phone', '03107085816', CupertinoIcons.phone),
              const SizedBox(height: 10),
              itemProfile('Email', 'ahadhashmideveloper@gmail.com',
                  CupertinoIcons.mail),
              const SizedBox(
                height: 60,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                    ),
                    child: const Text('Edit Profile')),
              )
            ],
          ),
        ),
      ),
    );
  }
}

itemProfile(String title, String subtitle, IconData iconData) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 5),
              color: Color.fromARGB(255, 139, 77, 158).withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 10)
        ]),
    child: ListTile(
      title: Text(
        title,
        style: TextStyle(color: Color.fromARGB(255, 168, 94, 190)),
      ),
      onTap: () {
        // Navigator.of(context).pushNamed("HomePage");
      },
      subtitle: Text(subtitle),
      leading: Icon(iconData),
      trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
      tileColor: Colors.white,
    ),
  );
}
