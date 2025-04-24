import 'package:cloud_firestore/cloud_firestore.dart';
class Complaint {
  final String title;
  final String description;
  final String imageUrl;
  final String address;
  final DateTime timestamp ;
  
  Complaint({required this.title,required this.description,
    required this.imageUrl,
    required this.address,
    required this.timestamp});
    
  factory Complaint.fromMap(Map<String, dynamic> data) {
    return Complaint(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      address: data['address'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}