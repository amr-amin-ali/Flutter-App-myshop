import 'package:flutter/material.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:provider/provider.dart';
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;

// ignore: must_be_immutable
class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool noOrders = false;

///////////////
//For the commented approach
  // late Future _ordersFuture;
  // Future _obtainOrders(BuildContext context) {
  //   return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  // }

  // @override
  // void initState() {
  //   _ordersFuture = _obtainOrders(context);
  //   super.initState();
  // }
//////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(CartScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart_outlined)),
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
              icon: Icon(Icons.shop)),
        ],
      ),
      drawer: AppDrawer(),

      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (_, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            //...Do While Waiting ....
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Loading your orders...')
                ],
              ),
            );
            //.................................................
          } else {
            if (dataSnapShot.error != null) {
              //.....Handle errors
              return Center(
                child: Text('Error ---  '),
              );
            } else {
              return Consumer<Orders>(builder: (ctx, orderData, child) {
                if (orderData.orders.length < 1) noOrders = true;
                return noOrders
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              elevation: 9,
                              shadowColor: Colors.cyan,
                              child: Container(
                                width: 100,
                                height: 100,
                                alignment: Alignment.center,
                                child: Text(
                                  'No orders yet.',
                                  style: TextStyle(
                                    color: Colors.grey[850],
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (ctx, index) =>
                            OrderItem(orderData.orders[index]),
                      );
              });
            }
          }
        },
      ),

      //*  [ANOTHER APPROACH]
      //*
      //* make the provider call out of the FutureBuilder
      //* why?
      //* that would be better if we want to call it once the screen built
      //* and not with every widget build
      //* when?
      //* if we want to call bulder once , but we have another
      //* state management that changes the state and we did not want to call the provider with every widget build on state change

      // body: FutureBuilder(
      //   future: _ordersFuture,
      //   builder: (_, dataSnapShot) {
      //     if (dataSnapShot.connectionState == ConnectionState.waiting) {
      //       //...Do While Waiting ....
      //       return Center(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             CircularProgressIndicator(),
      //             SizedBox(
      //               height: 20,
      //             ),
      //             Text('Loading your orders...')
      //           ],
      //         ),
      //       );
      //       //.................................................
      //     } else {
      //       if (dataSnapShot.error != null) {
      //         //.....Handle errors
      //         return Center(
      //           child: Text('Error ---  '),
      //         );
      //       } else {
      //         return Consumer<Orders>(builder: (ctx, orderData, child) {
      //           if (orderData.orders.length < 1) noOrders = true;
      //           return noOrders
      //               ? Padding(
      //                   padding: const EdgeInsets.symmetric(
      //                       horizontal: 20, vertical: 100),
      //                   child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.start,
      //                     crossAxisAlignment: CrossAxisAlignment.stretch,
      //                     children: [
      //                       Card(
      //                         elevation: 9,
      //                         shadowColor: Colors.cyan,
      //                         child: Container(
      //                           width: 100,
      //                           height: 100,
      //                           alignment: Alignment.center,
      //                           child: Text(
      //                             'No orders yet.',
      //                             style: TextStyle(
      //                               color: Colors.grey[850],
      //                               fontSize: 24,
      //                               fontWeight: FontWeight.bold,
      //                             ),
      //                           ),
      //                         ),
      //                       )
      //                     ],
      //                   ),
      //                 )
      //               : ListView.builder(
      //                   itemCount: orderData.orders.length,
      //                   itemBuilder: (ctx, index) =>
      //                       OrderItem(orderData.orders[index]),
      //                 );
      //         });
      //       }
      //     }
      //   },
      // ),
    );
  }
}
