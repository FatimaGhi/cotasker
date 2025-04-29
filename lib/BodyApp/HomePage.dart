import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotasker/core/myappbar.dart';
import 'package:cotasker/core/mybottonnavigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

int selectedindex = 0;
String passage = "/MyProject";
bool isChef = true;
String TitlePage = "My project";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String greetingMessage = '';
  String userName = '';
  String profilePictureUrl = '';
  List<String> pictureUrls = [
    'https://media.istockphoto.com/id/1286858263/vector/project-management-icon-clipboard-with-gear-isolated-icon-vector-illustration.jpg?s=612x612&w=0&k=20&c=2YrEtPB8_6-r-HJmiskFY9OVAI2T8XcH43nMKjjfD7c=',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRH7-pFPLd7TgHZ_QIl3GXhlueEPHL33tsqyaUVYmNV7zz0XA7IszThn_3COYgdkfFrnY0&usqp=CAU',
    'https://img.freepik.com/vector-gratis/equipo-trabajo_23-2148103569.jpg',
    'https://cdn-icons-png.freepik.com/512/1/1663.png',
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getUserInfo();
    setGreetingMessage();
  }

  Future<void> getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot userDoc;

      // Check in Chef_Project collection
      DocumentSnapshot chefDoc =
          await _firestore.collection('Chef_Project').doc(userId).get();
      if (chefDoc.exists) {
        setState(() {
          isChef = true;
          TitlePage = "My project";
          userName = chefDoc['firstName'];
          profilePictureUrl = chefDoc['profilePicture'];
        });
      } else {
        // If not found in Chef_Project, check in users collection
        userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          setState(() {
            isChef = false;
            TitlePage = "My Task";
            userName = userDoc['firstName'];
            profilePictureUrl = userDoc['profilePicture'];
          });
        }
      }
    }
  }

  void test() {
    getUserInfo();
    if (isChef == false) {
      passage = "mytask";
    }
  }

  void setGreetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greetingMessage = 'Good morning';
    } else if (hour < 17) {
      greetingMessage = 'Good afternoon';
    } else {
      greetingMessage = 'Good evening';
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/LoginPage');
  }

  @override
  Widget build(BuildContext context) {
    getUserInfo();
    return MaterialApp(
      home: Scaffold(
        appBar: myappbar("Home", context),
        bottomNavigationBar: mybottonnavigationbar(0, (val) {
          setState(() {
            selectedindex = val;
            if (selectedindex == 1) {
              test();
              Navigator.of(context).pushNamed(passage);
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
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: profilePictureUrl.isNotEmpty
                        ? NetworkImage(profilePictureUrl)
                        : null,
                    child: profilePictureUrl.isEmpty
                        ? Icon(Icons.person, size: 30)
                        : null,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$greetingMessage",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Hi, $userName",
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                "Welcome to the home page",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: pictureUrls.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      child: Image.network(
                        pictureUrls[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (isChef) {
                    Navigator.of(context).pushNamed('/MyProject');
                  } else {
                    Navigator.of(context).pushNamed('mytask');
                  }
                },
                child: Text("My Activity"),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
