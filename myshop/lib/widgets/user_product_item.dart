import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;
  UserProductItem({
    required this.id,
    required this.title,
    required this.imgUrl,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: id);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).errorColor,
            ),
            onPressed: () async {
              await Provider.of<Products>(context, listen: false)
                  .removeProduct(id)
                  .catchError((_) {
                // ignore: deprecated_member_use
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Deleting  failed!!!'),
                    duration: Duration(seconds: 1),
                  ),
                );
                ///////////////////////////////////////////
                // showDialog(
                //   //START SHOW DIALOG
                //   context: context,
                //   builder: (_) => AlertDialog(
                //     title: Text('Error'),
                //     content: Text('Cant delete product'),
                //     actions: [
                //       // ignore: deprecated_member_use
                //       FlatButton(
                //           onPressed: () {
                //             Navigator.of(context).pop();
                //           },
                //           child: Text('Cancel'))
                //     ],
                //   ),
                // ); //END SHOW DIALOG
                ////////////////////////////////////////////
                // ignore: deprecated_member_use
              });
            },
          )
        ]),
      ),
    );
  }
}
