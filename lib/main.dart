import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './screens/orders_screen.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: GoogleFonts.lato().fontFamily,
        ),
        initialRoute: ProductsOverViewScreen.screenId,
        routes: {
          ProductsOverViewScreen.screenId: (ctx) => ProductsOverViewScreen(),
          ProductDetailScreen.screenId: (ctx) => ProductDetailScreen(),
          CartScreen.screenId: (ctx) => CartScreen(),
          OrdersScreen.screenId: (ctx) => OrdersScreen(),
          UserProductsScreen.screenId: (ctx) => UserProductsScreen(),
          EditProductScreen.screenId: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
