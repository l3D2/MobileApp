import 'package:flutter/material.dart';

class EmptyCartMsgWidget extends StatelessWidget {
  const EmptyCartMsgWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
        child: SizedBox(
          height: size.height * .7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_basket,size: 100,color: Colors.grey,),
              const Text('Your cart is empty' ,style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Shop now')),
        ],
      ),
    ));
  }
}
