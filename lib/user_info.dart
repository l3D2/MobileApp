import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_pj/map.dart';
import 'package:food_pj/user_editinfo.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({Key? key}) : super(key: key);

  @override
  State createState() => _PersonalInfoPage();
}

class _PersonalInfoPage extends State<PersonalInfoPage> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final email = auth.currentUser?.email;

    return StreamBuilder<QuerySnapshot>(
      stream: getData(email),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text("ข้อมูลส่วนบุคคล"),
          ),
          body: buildData(data),
        );
      },
    );
  }

  Stream<QuerySnapshot> getData(String? email) {
    if (email == null || email.isEmpty) {
      // Handle the case where user is not logged in or email is empty
      return Stream.empty(); // Return an empty stream
    } else {
      return db.collection('user_info').where('email', isEqualTo: email).snapshots();
    }
  }

  Padding buildData(QuerySnapshot data) {
    // Use data to populate user information instead of hardcoded values
    final userData = data.docs.first.data() as Map<String, dynamic>; // Assuming single document
    // Extract name, address, phone number from userData
    final name = userData['name']; // Assuming 'name' field exists
    final address = userData['address']; // Assuming 'address' field exists
    final phoneNum = userData['phone']; // Assuming 'phoneNum' field exists

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),
            const Text(
              'ที่อยู่:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              address,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            const Text(
              'เบอร์โทร:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              phoneNum,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MapsPage())), icon: const Icon(Icons.map), label: Text("Mark location"),),
                ),
                Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage())), icon: const Icon(Icons.edit), label: Text("Edit Infomation"),)
                )              
              ]
            )
          ],
        ),
      );
  }
}
