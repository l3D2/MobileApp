import 'package:flutter/material.dart';
import 'package:food_pj/home.dart';

class BillPage extends StatelessWidget {
  Map data;
  BillPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10,),
          Expanded(
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40)
                      ),
                    ),
                    child: 
                        Column(
                          children: <Widget>[
                            Center(
                              child: Image.asset("assets/img/logo.png", width: 150, height: 150,),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'SWIZKY FOODS',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 245, 95, 41),
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10,left: 40),
                                  child: Row(
                                    children: [
                                      Text('หมายเลขคำสั่งซื้อ: ${data['orderID']}'),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10,left: 40),
                                  child: Row(
                                    children: [
                                      Text("อีเมลผู้สั่ง: ${data['orderBy']}"),
                                    ],
                                  ),
                                ),
                            ],),
                            const Divider(height: 40, color: Colors.black,),
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.only(right: 20, left: 20),
                                itemCount: data['orderItems'].length,
                                itemBuilder: (context, index) {
                                  final String itemName = data['orderItems'].keys.toList()[index];
                                  final item = data['orderItems'][itemName];
                                  return ListTile(
                                    title: Text('$itemName x ${item['quantity']}'),
                                    trailing: Text('${item['price']} ฿', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                  );
                                },
                              ),
                            ),
                            _buildTotal()
                          ],
                        ))),
                        const SizedBox(height: 10,),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => const Homepage()),(Route route) => false);
            },
            child: const Text('เสร็จสิ้น'),
          ),
        ],
      ),
    );
  }

  Widget _buildTotal() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('รวม ',style: TextStyle(fontSize: 18),),
          Text('${data['totalPrice']} ฿',style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}