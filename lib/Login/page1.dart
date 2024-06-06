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
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignInPage()));
                },
                child: Text('Sign in',
                    style: TextStyle(fontSize: 25, color: Colors.white)),
              ),
            ),
            // TextButton(
            //   style: TextButton.styleFrom(
            //     backgroundColor:
            //         Color.fromARGB(255, 141, 101, 186), // Background color
            //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            //     textStyle: TextStyle(fontSize: 16),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //   ),
            //   onPressed: () {
            //     // Action to perform when the button is pressed
            //     Navigator.of(context).push(
            //         MaterialPageRoute(builder: (context) => SignInPage()));
            //   },
            //   child: Text('Sign in',
            //       style: TextStyle(fontSize: 25, color: Colors.white)),
            // ),

            //BOTTON FOR Create Account
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreatAccountPage()));
              },
              style: TextButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 141, 101, 186), // Background color
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Create Account ',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
            // Container(
            //   alignment: Alignment.bottomCenter,
            //   child: Row(
            //     children: [
            //       Text("Teams of use"),
            //       Text("Privacy pollcy"),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    ));
  }
}
