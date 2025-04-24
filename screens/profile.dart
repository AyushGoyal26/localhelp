import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:local_help/screens/login/loginscreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _localityController = TextEditingController();

  bool _isLoading = true;
  bool _isEditing = false;
  late String userId;

  // Function to load user details from Firestore
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      try {
        final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        if (docSnapshot.exists) {
          var data = docSnapshot.data();
          _nameController.text = data?['name'] ?? '';
          _ageController.text = data?['age'].toString() ?? '';
          _localityController.text = data?['locality'] ?? '';
        } else {
          // If no data exists, leave fields blank
          _nameController.clear();
          _ageController.clear();
          _localityController.clear();
        }
      } catch (e) {
        print("Error loading user data: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Function to save updated user details to Firestore
  Future<void> _saveUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': _nameController.text,
        'age': int.tryParse(_ageController.text) ?? 0,
        'locality': _localityController.text,
      }, SetOptions(merge: true)); // Use merge to update only the fields that changed

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile updated successfully!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating profile: $e")));
    } finally {
      setState(() {
        _isLoading = false;
        _isEditing = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(
                          "https://static.vecteezy.com/system/resources/previews/054/078/735/non_2x/gamer-avatar-with-headphones-and-controller-vector.jpg", // Default profile image
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text("Name:", style: TextStyle(fontSize: 18)),
                          SizedBox(width: 20),
                          _isEditing
                              ? Expanded(
                                  child: TextField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Enter your name",
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Text(_nameController.text.isEmpty ? "No name added" : _nameController.text, style: TextStyle(fontSize: 18)),
                                ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text("Age:", style: TextStyle(fontSize: 18)),
                          SizedBox(width: 20),
                          _isEditing
                              ? Expanded(
                                  child: TextField(
                                    controller: _ageController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Enter your age",
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                )
                              : Expanded(
                                  child: Text(_ageController.text.isEmpty ? "No age added" : _ageController.text, style: TextStyle(fontSize: 18)),
                                ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text("Locality:", style: TextStyle(fontSize: 18)),
                          SizedBox(width: 20),
                          _isEditing
                              ? Expanded(
                                  child: TextField(
                                    controller: _localityController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Enter your locality",
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Text(_localityController.text.isEmpty ? "No locality added" : _localityController.text, style: TextStyle(fontSize: 18)),
                                ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _isEditing
                              ? ElevatedButton(
                                  onPressed: _saveUserData,
                                  child: Text("Save"),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.green,
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEditing = true;
                                    });
                                  },
                                  child: Text("Edit Profile"),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.blueAccent,
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text("Logout"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
