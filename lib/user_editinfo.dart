import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

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
          body: buildForm(data),
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

  Future _SaveProfile() async {
    if(_formKey.currentState!.validate()){
      final email = auth.currentUser?.email;
      final query = db.collection('user_info').where('email', isEqualTo: email);
      String docID = '';
      final data = {
        'name' : _nameController.text,
        'address' : _addressController.text,
        'phone' : _phoneController.text,
      };
      print(_nameController.text);
      try {
        final querySnapshot = await query.get();
        if (querySnapshot.docs.isNotEmpty) {
            final doc = querySnapshot.docs.first; // Assuming only one document matches
            docID = doc.id;
            print(docID);
        } else {
            print('No user found with email: $email');
        }
      } on FirebaseException catch (e) {
          print('Error retrieving user data: $e');
      }
      try {
        await db.collection('user_info').doc(docID).update(data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved successfully'),
          ),
        );
      } on FirebaseException catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved error ${error.message}'),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved error ${error.toString()}'),
          ),
        );
      }
      Navigator.pop(context);
    }
  }

  Padding buildForm(QuerySnapshot data) {
    final userData = data.docs.first.data() as Map<String, dynamic>; // Assuming single document
    // Extract name, address, phone number from userData
    _nameController.text = userData['name']; // Assuming 'name' field exists
    _addressController.text = userData['address']; // Assuming 'address' field exists
    _phoneController.text = userData['phone'];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ชื่อ-นามสกุล:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรุณากรอกชื่อ-นามสกุล';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'ที่อยู่:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _addressController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรุณากรอกที่อยู่';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'เบอร์โทร:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phoneController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'กรุณากรอกเบอร์โทร';
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return 'รูปแบบเบอร์โทรไม่ถูกต้อง';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.cancel),
                    label: const Text("ยกเลิก"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () => _SaveProfile(),
                    icon: const Icon(Icons.save),
                    label: const Text("บันทึก"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}