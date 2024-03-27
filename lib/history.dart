// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:food_pj/home.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class HistoryPage extends StatefulWidget {
//   @override
//   _HistoryPageState createState() => _HistoryPageState();
// }

// class _HistoryPageState extends State<HistoryPage> {
//   final db = FirebaseFirestore.instance;
//   final auth = FirebaseAuth.instance;
//   List<Map<String, dynamic>> orderData = [];
//   @override
//   Future<void> initState() async {
//     final email = auth.currentUser?.email;
//     super.initState();
//     // Query query = db.collection('order').where('orderBy',isEqualTo: email.toString());
//     // try {
//     //   final querySnapshot = await query.get();
//     //   for (var doc in querySnapshot.docs) {
//     //     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     //     print("Document ID: ${doc.id}");
//     //     print("Data: $data");

//     //     // Add the data to the list
//     //     orderData.add(data);
//     //   }
//     // } catch (e) {
//     //   print("Error getting documents: $e");
//     // }
//     db.collection('order').where('orderBy',isEqualTo: email.toString()).snapshots().listen((event) {
//       for (var doc in event.docs) {
//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         print("Document ID: ${doc.id}");
//         print("Data: $data");

//         // Add the data to the list
//         orderData.add(data);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final email = auth.currentUser?.email;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Firebase Data'),
//       ),
//       body: 
//       Column(children: [
//         ElevatedButton.icon(onPressed: () async {
//           Query query = db.collection('order').where('orderBy',isEqualTo: email.toString());
//           try {
//             final querySnapshot = await query.get();
//             for (var doc in querySnapshot.docs) {
//               Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//               //print("Document ID: ${doc.id}");
//               //("Data: $data");

//               // Add the data to the list
//               orderData.add(data);
//             }
//           } catch (e) {
//             print("Error getting documents: $e");
//           }
//           print(orderData);
//         }, icon: Icon(Icons.keyboard_command_key), label: Text("Test"))
//       ],)
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> orderData = []; // Store fetched data

  @override
  void initState() {
    super.initState();
    _fetchOrders(); // Fetch data on initialization
  }

  Future<void> _fetchOrders() async {
    try {
      final db = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;
      final email = auth.currentUser?.email;
      final query = db.collection('order').where('orderBy', isEqualTo: email.toString());
      final querySnapshot = await query.get();

      setState(() {
        orderData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    } catch (e) {
      // Handle errors appropriately, e.g., show an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return orderData.isEmpty
        ? const Center(child: Text('Loading orders...')) // Or a loading indicator
        : ListView.builder(
            itemCount: orderData.length,
            itemBuilder: (context, index) {
              final order = orderData[index];
              // Access order details from 'order' map
              return ListTile(
              title: Text('OrderID: ${order['orderID'] ?? 'Unknown Order'}'), // Access 'name' field or provide a default
              subtitle: Text('Quantity: ${order['orderItems'].length?.toString() ?? 'No data'}'), // Access 'date' field and format as string
              trailing: Text('${order['totalPrice']?.toString() ?? '---'} ฿'), // Access 'total' field and format as string
              );
            },
          );
  }
}
