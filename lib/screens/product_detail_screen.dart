import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static final String screenId = 'ProductDetailScreen';
//
//  final String title;
//  final double price;
//
//  ProductDetailScreen(this.title, this.price);

  @override
  Widget build(BuildContext context) {
    var productId = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
    );
  }
}
