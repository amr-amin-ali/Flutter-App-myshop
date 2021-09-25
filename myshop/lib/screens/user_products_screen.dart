import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          productsData.allItems.length < 1
              ? Text('')
              : IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProductScreen.routeName);
                  },
                ),
        ],
      ),
      drawer: AppDrawer(),
      body: productsData.allItems.length < 1
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 5,
                    child: Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'No products added yet',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.only(bottom: 10),
                            tooltip: 'Add product',
                            icon: const Icon(
                              Icons.add,
                              color: Colors.green,
                              size: 50,
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(EditProductScreen.routeName);
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: productsData.allItems.length,
                  itemBuilder: (_, i) => Column(children: [
                    UserProductItem(
                      id: productsData.allItems[i].id,
                      title: productsData.allItems[i].title,
                      imgUrl: productsData.allItems[i].imageUrl,
                    ),
                    Divider(),
                  ]),
                ),
              ),
            ),
    );
  }
}
