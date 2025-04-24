import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddComplaintScreen extends StatefulWidget {
  @override
  _AddComplaintScreenState createState() => _AddComplaintScreenState();
}

class _AddComplaintScreenState extends State<AddComplaintScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _imageUrlController = TextEditingController(); // Text controller for image URL

  final _formKey = GlobalKey<FormState>();

  Future<void> _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final description = _descriptionController.text;
      final address = _addressController.text;
      final imageUrl = _imageUrlController.text.isEmpty
          ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSoV5ll0kYfWfMtevUS9OR971Hxod__a_CvWQ&s' // Default image URL
          : _imageUrlController.text; // User-provided image URL

      try {
        await FirebaseFirestore.instance.collection('complaints').add({
          'title': title,
          'description': description,
          'address': address,
          'imageUrl': imageUrl, // Save image URL
          'timestamp': FieldValue.serverTimestamp(),
        });
        
        // Show success message and clear the form
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Complaint submitted successfully!')),
        );
        _titleController.clear();
        _descriptionController.clear();
        _addressController.clear();
        _imageUrlController.clear(); // Clear the image URL field

      } catch (error) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit complaint. Try again later.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Complaint'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.blue[50], // Light background color
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Add an image below the "Add Complaint" text
              Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSoV5ll0kYfWfMtevUS9OR971Hxod__a_CvWQ&s", // You can replace this with your image
                height: 120,
                width: 250,
              ),
              SizedBox(height: 20), // Space between image and form
              SizedBox(height: 20), // Space between title and form

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitComplaint,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: Text('Submit Complaint'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
