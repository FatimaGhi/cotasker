import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotasker/BodyApp/EditProfilePage.dart';
import 'package:cotasker/core/myappbar.dart';
import 'package:cotasker/core/mybottonnavigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String passage = "/MyProject";
bool isChef = true ;
String TitlePage = "My project";

class Profil_page extends StatefulWidget {
  const Profil_page({super.key, required Map<String, dynamic> userProfile});

  @override
  State<Profil_page> createState() => _Profil_pageState();
}

class _Profil_pageState extends State<Profil_page> {
  int selectedindex = 3;
  late User? user;
  late Map<String, dynamic> userProfile = {};
  bool isLoading = false;

  @override
  void initState() {
    // checkIfChef();

    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      fetchUserProfile();
    } else {
      // Handle case where user is not authenticated
      print("User is not authenticated.");
      checkIfChef();
      fetchUserProfile();
    }
  }

  void fetchUserProfile() async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> chefSnapshot =
          await FirebaseFirestore.instance
              .collection('Chef_Project')
              .doc(user!.uid)
              .get();

      if (chefSnapshot.exists) {
        setState(() {
          userProfile = chefSnapshot.data()!;
        });
      } else {
        // If not found in Chef_Project, check in the users collection
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .get();

        if (userSnapshot.exists) {
          setState(() {
            userProfile = userSnapshot.data()!;
          });
        } else {
          print("User profile not found in both collections.");
        }
      }
    } catch (error) {
      print("Failed to fetch user profile: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> checkIfChef() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;

      DocumentSnapshot doc =
          await _firestore.collection('Chef_Project').doc(userId).get();
      if (doc.exists) {
        setState(() {
          isChef = true;
          TitlePage = "My project";
        });
      } else {
        setState(() {
          isChef = false;
          TitlePage = "My Task";
        });
      }
    }
  }

  void test() {
    checkIfChef();
    if (isChef == false) {
      passage = "mytask";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: myappbar("MyProfile", context),
      bottomNavigationBar: mybottonnavigationbar(3, (val) {
        setState(() {
          selectedindex = val;
          if (selectedindex == 1) {
            test();
            Navigator.of(context).pushNamed("$passage");
          }
          if (selectedindex == 0) {
            Navigator.of(context).pushNamed("/HomePage");
          }
          if (selectedindex == 3) {
            Navigator.of(context).pushNamed("/ProfilPage");
          }
          if (selectedindex == 2) {
            Navigator.of(context).pushNamed("/NotiPage");
          }
        });
      }, TitlePage),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : userProfile.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      // CircleAvatar(
                      //   radius: 70,
                      //   backgroundImage: AssetImage('assets/images/user.JPG'),
                      // ),
                      const SizedBox(height: 20),
                      itemProfile('Frist Name', userProfile['firstName'] ?? '',
                          CupertinoIcons.person),
                      const SizedBox(height: 10),
                      itemProfile('last Name', userProfile['lastName'] ?? '',
                          CupertinoIcons.person),
                      const SizedBox(height: 10),
                      itemProfile('Phone', userProfile['N_tel'] ?? '',
                          CupertinoIcons.phone),
                      const SizedBox(height: 10),
                      itemProfile('Email', userProfile['email'] ?? '',
                          CupertinoIcons.mail),
                      const SizedBox(
                        height: 60,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfilePage(
                                        userProfile: userProfile),
                                  ));
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                            ),
                            child: const Text('Edit Profile')),
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      'User profile not found',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
      ),
    ));
  }
}

Widget itemProfile(String title, dynamic subtitle, IconData iconData) {
  String subtitleText = subtitle.toString();
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
      subtitle: Text(subtitleText),
      leading: Icon(iconData),
      trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
      tileColor: Colors.white,
    ),
  );
}
