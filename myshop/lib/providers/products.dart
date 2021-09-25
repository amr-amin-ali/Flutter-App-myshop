import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String? token;
  Products(
    this.token,
    this._items,
  );

get authToken{
  return token;
}
  Future<void> fetchAndSetProducts() async {
    try {
      final response = await http.get(Uri.parse(
          'https://myshop-e5973-default-rtdb.firebaseio.com/products.json?auth=$token'));

      if (response.body != 'null') {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;

        final List<Product> loadedProductsLIst = [];
        extractedData.forEach((productId, productData) {
          loadedProductsLIst.insert(
              0,
              Product(
                id: productId,
                description: productData['description'],
                imageUrl: productData['imageUrl'],
                price: productData['price'],
                title: productData['title'],
                isFavorite: productData['isFavorite'],
              ));
        });
        _items = loadedProductsLIst;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  List<Product> get allItems {
    return [..._items];
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://myshop-e5973-default-rtdb.firebaseio.com/products.json?auth=$token');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'title': product.title,
            'isFavorite': product.isFavorite
          }, //json object
        ), //encode
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _items.insert(0, newProduct);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProductData) async {
    final productIndex = _items.indexWhere((pro) => pro.id == id);
    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://myshop-e5973-default-rtdb.firebaseio.com/products/$id.json?auth=$token');

      await http.patch(url,
          body: json.encode({
            'title': newProductData.title,
            'description': newProductData.description,
            'imageUrl': newProductData.imageUrl,
            'price': newProductData.price,
          }));
      _items[productIndex] = newProductData;
      notifyListeners();
    }
  }

  Future<void> removeProduct(String id) async {
    if (id != '') {
      final url = Uri.parse(
          'https://myshop-e5973-default-rtdb.firebaseio.com/products/$id.json?auth=$token');

      var response = await http.delete(url);
      // print('=================================');
      // print('== response.body => ' + response.body.toString());
      // print('== response.statusCode => ' + response.statusCode.toString());
      // print('== response.persistentConnection => ' +
      //     response.persistentConnection.toString());
      // print('=================================');
      if (response.statusCode == 200) {
        final existingProductIndex =
            _items.indexWhere((product) => product.id == id);

        // var existingProduct = _items[existingProductIndex];

        _items.removeAt(existingProductIndex);

        notifyListeners();
      } else {
        throw Exception('Cant delete product');
      }
    }
  }

  List<Product> get favoritItems {
    return [..._items].where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((p) => p.id == id);
  }
}
