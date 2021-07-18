import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bill_calculator_flutter/services/services.dart';
import 'package:bill_calculator_flutter/shared/drawer.dart';
import 'package:bill_calculator_flutter/shared/item_list.dart';
import 'package:bill_calculator_flutter/services/models.dart';
import 'package:bill_calculator_flutter/route_generator.dart';

enum billMenu { calculate, changeImage, delete }

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
                      expandedHeight: 240,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(bill.name),
                        background: Image.network(
                          bill.image != ''
                              ? bill.image
                              : 'https://i.pinimg.com/originals/94/de/9e/94de9e47d14a839b5e1ed98fd5252fab.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(0),
                        child: Transform.translate(
                          offset: const Offset(-150, -3),
                          child: PopupMenuButton(
                            onSelected: (billMenu val) {
                              if (val == billMenu.calculate) {
                                Navigator.of(context).pushNamed(
                                  '/calculate',
                                  arguments: CalculateScreenArguments(
                                    bill: bill,
                                    items: items,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.expand_more),
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem(
                                value: billMenu.calculate,
                                child: Text('Calculate'),
                              ),
                              const PopupMenuItem(
                                value: billMenu.changeImage,
                                child: Text('Change image'),
                              ),
                              const PopupMenuItem(
                                value: billMenu.delete,
                                child: Text('Delete bill'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    ItemList(
                      items: sortedItems,
                      billId: bill.uid,
                      onTap: (sharedBy, itemId) =>
                          StoreService().updateItem(sharedBy, itemId, billId),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 50),
                    )
                  ],
                ),
              );
            },
          );
        } else {
          // else billId = 'empty'
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
