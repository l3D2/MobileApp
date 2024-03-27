import 'package:flutter/material.dart';
import 'package:food_pj/history.dart';
import 'package:food_pj/nav_bar.dart';
import 'package:food_pj/nav_model.dart';
import 'package:food_pj/listfood.dart';
import 'package:food_pj/shop_cart/cart_view.dart';
import 'package:persistent_shopping_cart/persistent_shopping_cart.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final homeNavKey = GlobalKey<NavigatorState>();
  final searchNavKey = GlobalKey<NavigatorState>();
  final orderNavKey = GlobalKey<NavigatorState>();
  final profileNavKey = GlobalKey<NavigatorState>();
  int selectedTab = 0;
  List<NavModel> items = [];

  @override
  void initState() {
    super.initState();
    items = [
      NavModel(
        page: ProductsScreen(),
        navKey: homeNavKey,
      ),
      // NavModel(
      //   page: const TabPage(tab: 2),
      //   navKey: searchNavKey,
      // ),
      NavModel(
        page: const HistoryPage(),
        navKey: orderNavKey,
      ),
      // NavModel(
      //   page: const TabPage(tab: 4),
      //   navKey: profileNavKey,
      // ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (items[selectedTab].navKey.currentState?.canPop() ?? false) {
          items[selectedTab].navKey.currentState?.pop();
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: selectedTab,
          children: items
              .map((page) => Navigator(
                    key: page.navKey,
                    onGenerateInitialRoutes: (navigator, initialRoute) {
                      return [
                        MaterialPageRoute(builder: (context) => page.page)
                      ];
                    },
                  ))
              .toList(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          margin: const EdgeInsets.only(top: 25),
          height: 60,
          width: 60,
          child: 
            FloatingActionButton(
              backgroundColor: Colors.white,
              elevation: 0,
              onPressed: () {},
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 3, color: Colors.green),
                borderRadius: BorderRadius.circular(100),
              ),
              child: PersistentShoppingCart().showCartItemCountWidget(
                cartItemCountWidgetBuilder: (itemCount) => IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartView()),
                    );
                  },
                  icon: Badge(
                    label:Text(itemCount.toString()) ,
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                )
              )
            ),
        ),
        bottomNavigationBar: NavBar(
          pageIndex: selectedTab,
          onTap: (index) {
            if (index == selectedTab) {
              items[index]
                  .navKey
                  .currentState
                  ?.popUntil((route) => route.isFirst);
            } else {
              setState(() {
                selectedTab = index;
              });
            }
          },
        ),
      ),
    );
  }
}

class TabPage extends StatelessWidget {
  final int tab;

  const TabPage({Key? key, required this.tab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tab $tab')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tab $tab'),
          ],
        ),
      ),
    );
  }
}