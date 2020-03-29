import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/products.dart';
import './screens/products_overview_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import './screens/product_detail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
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
        },
      ),
      create: (_) => Products(),
    );
  }
}
