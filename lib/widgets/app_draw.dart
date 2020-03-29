import 'package:flutter/material.dart';
import '../screens/orders_screen.dart';
import '../screens/products_overview_screen.dart';

class AppDraw extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductsOverViewScreen.screenId);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Payment'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrdersScreen.screenId);
            },
          ),
        ],
      ),
    );
  }
}
