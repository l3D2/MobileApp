// example's main.dart
import 'package:flutter/material.dart';
import 'package:food_pj/shop_cart/component/cart_tile_widget.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:food_pj/shop_cart/model/item_model.dart';

import 'shop_cart/component/empty_cart_msg_widget.dart';

class ProductsScreen extends StatelessWidget {
   ProductsScreen({super.key});

  List<ItemModel> itemsList = const [
    ItemModel(productId: '1', productName: 'Fried Fish Burger' ,productDescription: 'Served with fries & coleslaw' , productThumbnail: 'https://img2.pic.in.th/pic/Logo-300.png' , unitPrice: 30, ),
    ItemModel(productId: '2' ,productName: 'Loaded Beef Jalapeno' ,productDescription: '200g Premium beef with jalapeno sauce' , productThumbnail: 'https://img2.pic.in.th/pic/Logo-300.png' , unitPrice: 30, ),
    ItemModel(productId: '3',productName: 'Crispy Penny Pasta' ,productDescription: 'Creamy mushroom sauce with three types of bell pepper mushrooms & fried breast fillet' , productThumbnail: 'https://img2.pic.in.th/pic/Logo-300.png' , unitPrice: 50, ),
    ItemModel(productId: '4',productName: 'Moroccan Fish' ,productDescription: "Fried filet of fish served with Moroccan sauce sided by veggies & choice of side" , productThumbnail: 'https://img2.pic.in.th/pic/Logo-300.png' , unitPrice: 20, ),
    ItemModel(productId: '5',productName: 'Creamy Chipotle' ,productDescription: 'Grilled chicken fillet topped with chipotle sauce' , productThumbnail: 'https://img2.pic.in.th/pic/Logo-300.png' , unitPrice: 40, ),
    ItemModel(productId: '6',productName: 'Onion Rings' ,productDescription: '10 imported crumbed onion rings served with chilli garlic sauce' , productThumbnail: 'https://img2.pic.in.th/pic/Logo-300.png' , unitPrice: 5 ),
    ItemModel(productId: '7',productName: 'Pizza Fries' ,productDescription: 'French fries topped with chicken chunks & pizza sauce with Nachos & cheese' , productThumbnail: 'https://img2.pic.in.th/pic/Logo-300.png' , unitPrice: 10, ),
  ] ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Persistent Shopping Cart' , style: TextStyle(fontSize: 15),),
      //   centerTitle: true,
      //   actions: [
      //     PersistentShoppingCart().showCartItemCountWidget(
      //       cartItemCountWidgetBuilder: (itemCount) => IconButton(
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => const CartView()),
      //           );
      //         },
      //         icon: Badge(
      //           label:Text(itemCount.toString()) ,
      //           child: const Icon(Icons.shopping_bag_outlined),
      //         ),
      //       ),
      //     ),
      //     const SizedBox(width: 20.0)
      //   ],
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView.builder(
              itemCount: itemsList.length,
              itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: GestureDetector(
                    onTap: () {
                      print(index);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => showDetail(id: itemsList[index].productId,name: itemsList[index].productName,description: itemsList[index].productDescription,image: itemsList[index].productThumbnail,price: itemsList[index].unitPrice),
                        ),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ClipRRect(
                                  child: Image.network(itemsList[index].productThumbnail.toString(),width: 100,height: 100,),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(itemsList[index].productName ,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700 , color: Colors.black),
                                      ),
                                      Text(itemsList[index].productDescription ,
                                        maxLines: 2,
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 5,),
                                      Text(r"$"+itemsList[index].unitPrice.toString() ,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                      Align(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            PersistentShoppingCart().showAndUpdateCartItemWidget(
                                              inCartWidget: Container(
                                                height: 30,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  border: Border.all(color: Colors.red),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Remove',
                                                    style: Theme.of(context).textTheme.bodySmall,
                                                  ),
                                                ),
                                              ),
                                              notInCartWidget: Container(
                                                height: 30,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.green),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                                  child: Center(
                                                    child: Text(
                                                      'Add to cart',
                                                      style: Theme.of(context).textTheme.bodySmall,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              product: PersistentShoppingCartItem(
                                                productId: index.toString(),
                                                productName: itemsList[index].productName,
                                                productDescription: itemsList[index].productDescription,
                                                unitPrice: double.parse(itemsList[index].unitPrice.toString()),
                                                productThumbnail: itemsList[index].productThumbnail.toString(),
                                                quantity: 1
                                            ),
                                          ),
                                          ],
                                        )
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                    ),
                  ),
                  )
                );
              }),
        ),
      ),
    );
  }
}

class showDetail extends StatelessWidget {
  final String id,image,name,description;
  final double price;
  showDetail({Key? key, required this.id, required this.image, required this.name, required this.description, required this.price});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: const Color.fromARGB(186, 199, 198, 198),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 15,
                  ),
                  Image(
                    image: NetworkImage(image),
                    width: 200,
                    height: 200,
                  ),
                  Text(description,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40), // มุมมนด้านบนซ้าย
                        topRight: Radius.circular(40), // มุมมนด้านบนขวา
                      ),
                    ),
                    child: 
                        Column(
                          children: <Widget>[
                            const Center(
                              child: Text(
                                'Review',
                                style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 40,),
                                SizedBox(width: 5,),
                                Text('4.5', style: TextStyle(fontSize: 25),),
                            ],),
                            Expanded(
                              child: ListView(
                                padding: const EdgeInsets.only(
                                    top: 10, right: 20, left: 20),
                                children: const [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ))),
          ],
        )
    );
  }
}