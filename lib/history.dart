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
