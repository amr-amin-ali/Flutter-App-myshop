import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  void toggleFavorite(String token) async {
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://myshop-e5973-default-rtdb.firebaseio.com/products/$id.json?auth=$token');

    try {
      final response = await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        isFavorite = !isFavorite;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = !isFavorite;
      notifyListeners();
    }
  }
}
