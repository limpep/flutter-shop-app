import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_draw.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static final screenId = 'OrdersScreen';

  Future<void> _handleRefresh(BuildContext context) async {
    await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDraw(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          switch (dataSnapshot.connectionState) {
            case ConnectionState.none:
              return Text('Press button to start.');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              return RefreshIndicator(
                  child: Consumer<Orders>(
                    builder: (ctx, orderData, child) => ListView.builder(
                      itemBuilder: (ctx, index) => OrderItem(
                        orderData.orders[index],
                      ),
                      itemCount: orderData.orders.length,
                    ),
                  ),
                  onRefresh: () => _handleRefresh(context));
              break;
            default:
              return null;
          }
        },
      ),
    );
  }
}
