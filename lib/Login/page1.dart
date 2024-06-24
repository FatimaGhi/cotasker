import 'package:flutter/material.dart';
import 'package:cotasker/Login/SignInPage.dart';
import 'package:cotasker/Login/CreateAccoint.dart';

class Loginf extends StatefulWidget {
  const Loginf({super.key});
  @override
  State<Loginf> createState() => _LoginState();
}

class _LoginState extends State<Loginf> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/3.png",
              alignment: Alignment.center,
              width: 350,
              height: 300,
            ),
            //BOTTON FOR Sign in
            Container(
              margin: EdgeInsets.only(bottom: 30),
              width: 250,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 141, 101, 186), // Background color
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Action to perform when the button is pressed
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SignInPage()));
                },
                child: Text('Sign in',
                    style: TextStyle(fontSize: 25, color: Colors.white)),
              ),
            ),

            //BOTTON FOR Create Account
            Container(
              width: 250,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => CreatAccountPage()));
                },
                style: TextButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 233, 229, 238), // Background color
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  side: BorderSide(
                      color: Color.fromARGB(0,75, 0, 130), width: 2),
                  textStyle: TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Create Account ',
                  style: TextStyle(
                      fontSize: 25, color: Color.fromARGB(255, 58, 8, 150)),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 200),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      "Teams of use",
                    ),
                  ),
                  Container(
                    child: Text(
                      "Privacy pollcy",
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
