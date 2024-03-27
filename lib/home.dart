import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_pj/drawer.dart';
import 'package:food_pj/mainscreen.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swizky Foods'),
        backgroundColor: Colors.green
      ),
      drawer: const MyDrawerBody(),
      body: const MainScreen()
    );
  }
}