import 'package:flutter/material.dart';
import '../models/complaint.dart';

class ComplaintDetailScreen extends StatelessWidget {
  final Complaint complaint;
  const ComplaintDetailScreen({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Complaint"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(complaint.imageUrl,width: double.infinity,height: 200,fit: BoxFit.cover,),


          ),
          SizedBox(
            height: 16,
          ),
          Text(complaint.title,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
          SizedBox(
            height: 8,
          ),
          Text(complaint.address,style: TextStyle(fontSize: 16,color: Colors.grey),),
          SizedBox(
            height: 8,
          ),
          Text(complaint.description,style: TextStyle(fontSize: 16),),
          const SizedBox(height: 16),
            Text(
              "Reported on: ${complaint.timestamp.day}/${complaint.timestamp.month}/${complaint.timestamp.year}",
              style: const TextStyle(fontSize: 14, color: Colors.black54),)

          ],
        ),
      ),

    );
  }
}