import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotasker/BodyApp/profil_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userProfile;

  const EditProfilePage({Key? key, required this.userProfile})
      : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

bool isChef = false;

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.userProfile['firstName']);
    _lastNameController =
        TextEditingController(text: widget.userProfile['lastName']);
    _phoneController = TextEditingController(text: widget.userProfile['N_tel']);
    _emailController = TextEditingController(text: widget.userProfile['email']);

    checkIfChef(); // Call checkIfChef when the state is initialized
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
        });
      } else {
        setState(() {
          isChef = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    // Ensure isChef is set before proceeding
    await checkIfChef();

    // Get current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;

      // Determine which collection to update based on user type
      String collectionName = isChef ? 'Chef_Project' : 'users';

      // Prepare updated data
      Map<String, dynamic> updatedData = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'N_tel': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
      };

      try {
        // Update Firestore document
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(userId)
            .update(updatedData);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );

        // Navigate to ProfilePage with updated data
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Profil_page(userProfile: updatedData),
          ),
        );
      } catch (error) {
        // Handle errors
        print('Failed to update profile: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Color.fromARGB(255, 141, 101, 186),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 141, 101, 186)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 141, 101, 186)),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 141, 101, 186)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 141, 101, 186)),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 141, 101, 186)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 141, 101, 186)),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 141, 101, 186)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 141, 101, 186)),
                  ),
                ),
              ),
              SizedBox(height: 60),
              Center(
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor:
                        Color.fromARGB(255, 141, 101, 186), // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text('Save Changes', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
