import 'package:flutter/cupertino.dart';
import 'package:myshop/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.date,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  Future<void> fetchAndSetOrders() async {
    try {
      final response = await http.get(Uri.parse(
          'https://myshop-e5973-default-rtdb.firebaseio.com/orders.json'));

      if (response.body == 'null') return;

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<OrderItem> loadedProductsLIst = [];
      extractedData.forEach((orderId, orderData) {
        loadedProductsLIst.insert(
          0,
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            date: DateTime.parse(orderData['date']),
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['id'].toString(),
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price']))
                .toList(),
          ),
        );
      });
      _orders = loadedProductsLIst;
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://myshop-e5973-default-rtdb.firebaseio.com/orders.json');
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'date': timeStamp.toIso8601String(),
            'products': cartProducts
                .map((cartProduct) => {
                      'id': cartProduct.id,
                      'title': cartProduct.title,
                      'price': cartProduct.price,
                      'quantity': cartProduct.quantity,
                    })
                .toList(),
          }));
      if (response.statusCode == 200) {
        _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: total,
              products: cartProducts,
              date: timeStamp),
        );
        notifyListeners();
      }
    } catch (error) {}
  }
}
