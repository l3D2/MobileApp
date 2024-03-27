import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food_pj/bill.dart';
import 'package:food_pj/notification.dart';
import 'package:persistent_shopping_cart/model/cart_model.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';
import 'package:food_pj/shop_cart/component/cart_tile_widget.dart';
import 'package:food_pj/shop_cart/component/empty_cart_msg_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: Colors.green
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Expanded(
                child: PersistentShoppingCart().showCartItems(
                  cartTileWidget: ({required data}) => CartTileWidget(data: data),
                  showEmptyCartMsgWidget: const EmptyCartMsgWidget(),
                ),
              ),
              PersistentShoppingCart().showTotalAmountWidget(
                cartTotalAmountWidgetBuilder: (totalAmount) =>
                    Visibility(
                      visible: totalAmount == 0.0 ? false: true,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total', style: TextStyle(color: Colors.black , fontSize: 22),),
                              Text(r"$"+totalAmount.toString(), style: const TextStyle(color: Colors.black , fontSize: 22),),
                            ],
                          ),
                          ElevatedButton(onPressed: (){
                            final shoppingCart = PersistentShoppingCart();
                            // Retrieve cart data and total price
                            Map<String, dynamic> cartData = shoppingCart.getCartData();
                            // Extract cart items and total price
                            List<PersistentShoppingCartItem> cartItems = cartData['cartItems'];
                            double totalPrice = cartData['totalPrice'];
                            _createOrder(cartData);
                            log('Total Price: $totalPrice');
                          },style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green.shade300)), child: const Text('Checkout', style: TextStyle(color: Colors.white),))
                        ],
                      ),
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _createOrder(cart) async {
    final email = auth.currentUser?.email;
    String itemName,itemAmount,itemPrice;
    Map<String,dynamic> order = {};
    for (var item in cart['cartItems']){
      itemName = item.productName;
      itemAmount = item.quantity.toString();
      itemPrice = item.unitPrice.toString();
      order.putIfAbsent(itemName, () => {
        "quantity": itemAmount,
        "price": itemPrice,
      });
    }
    final data = {
      'orderID': DateTime.now().millisecondsSinceEpoch.toString(),
      'orderBy': email,
      'orderItems': order,
      'totalPrice': cart['totalPrice'].toString(),
    };
    await NotificationHelper.showNotification("Swizky Foods", "ทำการสั่งออเดอร์เรียบร้อย!!");
    PersistentShoppingCart().clearCart();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BillPage(data: data),
      ),
    );
    try {
      DocumentReference ref = await db.collection('order').add(data);
      print('Save registration = ' + ref.id);
    }catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error save registration $e'),duration: Duration(milliseconds: 500))
      );
    }
  }
}