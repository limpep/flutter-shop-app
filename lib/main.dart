import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import './screens/spash_screen.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';
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
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => null,
          update: (ctx, auth, previousProducts) => Products(
              auth.token,
              previousProducts == null ? [] : previousProducts.items,
              auth.userId),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => null,
          update: (ctx, auth, previousOrder) => Orders(auth.token, auth.userId,
              previousOrder == null ? [] : previousOrder.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: GoogleFonts.lato().fontFamily,
          ),
          home: auth.isAuth
              ? ProductsOverViewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapShot) =>
                      authResultSnapShot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductsOverViewScreen.screenId: (ctx) => ProductsOverViewScreen(),
            ProductDetailScreen.screenId: (ctx) => ProductDetailScreen(),
            CartScreen.screenId: (ctx) => CartScreen(),
            OrdersScreen.screenId: (ctx) => OrdersScreen(),
            UserProductsScreen.screenId: (ctx) => UserProductsScreen(),
            EditProductScreen.screenId: (ctx) => EditProductScreen(),
            AuthScreen.screenId: (ctx) => AuthScreen(),
            SplashScreen.screenId: (ctx) => SplashScreen(),
          },
        ),
      ),
    );
  }
}
