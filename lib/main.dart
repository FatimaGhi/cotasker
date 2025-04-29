import 'package:cotasker/BodyApp/CreatProject.dart';
import 'package:cotasker/BodyApp/HomePage.dart';
import 'package:cotasker/BodyApp/InfoProject.dart';
import 'package:cotasker/BodyApp/InfoTask.dart';
import 'package:cotasker/BodyApp/MyProject.dart';
import 'package:cotasker/BodyApp/NotiPage.dart';
import 'package:cotasker/BodyApp/creat_Task.dart';
import 'package:cotasker/BodyApp/my_task.dart';
import 'package:cotasker/BodyApp/profil_page.dart';
import 'package:cotasker/Login/CreateAccoint.dart';
import 'package:cotasker/Login/SignInPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cotasker/Login/page1.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //     options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
  // This widget is the root of your application.
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('************************* User is currently signed out!');
      } else {
        print('*************************User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,

      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? Loginf()
          : HomePage(),
      // home: MyProject(),
      routes: {
        // '/': (context) => HomePage(),
        "/signin": (context) => SignInPage(),
        "/creatAccount": (context) => CreatAccountPage(),
        "/HomePage": (context) => HomePage(),
        "/MyProject": (context) => MyProject(),
        "/CreatProject": (context) => CreatProject(),
        // "/Creat_task": (context) =>  Creat_task(),
        "/ProfilPage": (context) => Profil_page(
              userProfile: {},
            ),
        "/NotiPage": (context) => NotiPage(),
        "mytask": (context) => my_task(),
        // "/Info_project": (context) => InfoProject(idProject: String v)
      },
    );
  }
  
  
}
