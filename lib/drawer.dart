import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_pj/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyDrawerBody extends StatefulWidget {
  const MyDrawerBody({Key? key}) : super(key: key);

  @override
  State<MyDrawerBody> createState() => _MyDrawerBodyState();
}

class _MyDrawerBodyState extends State<MyDrawerBody> {
  final auth = FirebaseAuth.instance;
  late String _image;
  late String _displayName;

  @override
  void initState() {
    super.initState();
    _displayName = auth.currentUser?.displayName ?? 'None displayname';
    _image = auth.currentUser?.photoURL?? 'none';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.greenAccent),
            accountName: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 6.0),
                  child: Icon(Icons.account_circle),
                ),
                Text(_displayName, style: const TextStyle(color: Colors.black)),
              ],
            ),
            accountEmail: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 6.0),
                  child: Icon(Icons.email),
                ),
                Text(auth.currentUser?.email ?? 'No email', style: const TextStyle(color: Colors.black),),
              ],
            ),
            otherAccountsPictures: [
              GestureDetector(
                onTap: () => _showEditNamePopup(context),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.edit),
                ),
              ),
            ],
            currentAccountPicture: Column(
              children: [
                GestureDetector(
                  onTap: () => onChooseImage(context),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: _image != 'none' ? Image.network(_image ,width: 40, height: 40) : const Icon(Icons.person),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Your Infomation'),
            onTap: () => Navigator.pushNamed(context, '/uinfo'),
          ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {
              auth.signOut();
              Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => const LoginPage()),(Route route) => route == const LoginPage(),);
            },
          ),
        ],
      ),
    );
  }

  // void onChooseImage(BuildContext context) async {
  //   try {
  //     final picker = ImagePicker();
  //     final pickedFile = await picker.pickImage(
  //       source: ImageSource.camera,
  //     );
  //     if (pickedFile != null) {
  //       setState(() {
  //         _image = File(pickedFile.path);
  //       });
  //     } else {
  //       print('No image selected.');
  //     }
  //   } catch (e) {
  //     print('Error picking image: $e');
  //   }
  // }

void onChooseImage(BuildContext context) async {
  try {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('user_images/${pickedFile.path.split('/').last}');
      final uploadTask = storageRef.putFile(File(pickedFile.path));

      // Show a progress indicator or loading dialog (optional)
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await uploadTask.whenComplete(() => Navigator.pop(context)); // Hide progress indicator

      // Get the download URL after successful upload
      final imageUrl = await uploadTask.snapshot.ref.getDownloadURL();

      // Update user profile picture
      auth.currentUser?.updatePhotoURL(imageUrl);

      // Update local image state for preview (after successful upload)
      setState(() {
        _image = imageUrl;
      });
    } else {
      print('No image selected.');
    }
  } catch (e) {
    print('Error picking image: $e');
    // Handle other potential errors (e.g., network errors, permission issues)
  }
}

  void _showEditNamePopup(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: _displayName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Account Name'),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter your new name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newName = nameController.text.trim();
                if (newName.isEmpty) {
                  return;
                }

                // Update display name asynchronously
                auth.currentUser?.updateDisplayName(newName).then((_) {
                  // UI update only after successful update
                  setState(() {
                    _displayName = newName;
                  });
                }).catchError((error) {
                  // Handle update errors (optional)
                  print('Error updating display name: $error');
                });

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
