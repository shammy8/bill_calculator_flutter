import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bill_calculator_flutter/services/services.dart';
import 'package:bill_calculator_flutter/shared/drawer.dart';
import 'package:bill_calculator_flutter/shared/item_list.dart';
import 'package:bill_calculator_flutter/services/models.dart';

class BillScreen extends StatelessWidget {
  final AuthService auth = AuthService();
  final String billId;
  BillScreen({required this.billId});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    // if (user == null) {
    //   Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    // }

    return StreamProvider<List<Bill>>.value(
      value: StoreService().getAllBills(user!.uid),
      initialData: const [],
      builder: (context, child) {
        final List<Bill> bills = context.watch<List<Bill>>();

        if (billId != 'empty') {
          return StreamProvider<List<Item>>.value(
            value: StoreService().getAllItems(billId),
            initialData: const [],
            builder: (context, child) {
              final List<Item> items = context.watch<List<Item>>();
              List<Item> sortedItems = List.from(
                  items); // need to copy it before you can sort the above
              sortedItems.sort((a, b) => b.date.compareTo(a.date));
              final Bill bill = bills.firstWhere(
                (bill) => bill.uid == billId,
                orElse: () => Bill.fromMap({
                  // handle when items stream is still loading
                  'friends': [],
                  'editors': {},
                }, ''),
              );

              return Scaffold(
                endDrawer: BillDrawer(),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/add_item',
                      arguments: bill,
                    );
                  },
                  child: const Icon(Icons.add),
                ),
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      floating: true,
                      expandedHeight: 240,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(bill.name),
                        background: Image.network(
                          'https://thumbs-prod.si-cdn.com/6MmkyNmsODbteKNYiAMz6201KOw=/800x600/filters:no_upscale():focal(2062x722:2063x723)/https://public-media.si-cdn.com/filer/20/85/2085a351-1759-4b7e-bb3e-eadec17b7aef/papageitaucher_fratercula_arctica.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    ItemList(
                        items: sortedItems,
                        billId: bill.uid,
                        onTap: (sharedBy, itemId) =>
                            StoreService().updateItem(sharedBy, itemId, billId))
                  ],
                ),
              );
            },
          );
        } else {
          return Scaffold(
            appBar: AppBar(),
            endDrawer: BillDrawer(),
            body: const Center(
              child: Text('Add / choose a bill in the side menu'),
            ),
          );
        }
      },
    );
  }
}
