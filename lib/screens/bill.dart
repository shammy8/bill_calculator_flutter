import 'package:intl/intl.dart';
import 'package:bill_calculator_flutter/shared/items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bill_calculator_flutter/services/services.dart';
import 'package:bill_calculator_flutter/shared/drawer.dart';
import 'package:bill_calculator_flutter/services/models.dart';

class BillScreen extends StatelessWidget {
  final AuthService auth = AuthService();
  final String billId;
  final oCcy = new NumberFormat("#,##0.00", "en_US");
  BillScreen({required this.billId});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    // if (user == null) {
    //   Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    // }

    return MultiProvider(
      providers: [
        StreamProvider<List<Bill>>.value(
          value: StoreService().getAllBills(user!.uid),
          initialData: [],
        ),
        StreamProvider<List<Item>>.value(
          value: StoreService().getAllItems(billId),
          initialData: [],
        ),
      ],
      builder: (context, child) {
        final List<Bill> bills = context.watch<List<Bill>>();
        final items = context.watch<List<Item>>();
        if (billId != 'empty') {
          Bill bill = bills.firstWhere((bill) => bill.uid == billId);
          return Scaffold(
            endDrawer: BillDrawer(),
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
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        Item item = items[index];
                        List<SharedByElement> sharedBy = item.sharedBy;

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item.description,
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                Text(oCcy.format(item.cost),
                                    style:
                                        Theme.of(context).textTheme.headline6),
                              ],
                            ),
                            TwoSidedCheckableList(
                              sharedBy: item.sharedBy,
                              onTap: (sharedByElement, newValue) {
                                // print(sharedByElement);
                                sharedBy = sharedBy.map((element) {
                                  if (sharedByElement.friend ==
                                      element.friend) {
                                    return SharedByElement.fromMap({
                                      'friend': sharedByElement.friend,
                                      'settled': newValue
                                    });
                                  } else {
                                    return element;
                                  }
                                }).toList();
                                StoreService()
                                    .updateItem(sharedBy, item.id, bill.uid);
                              },
                            ),
                            Divider(),
                          ],
                        );
                      },
                      childCount: items.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(),
            endDrawer: BillDrawer(),
            body: Center(
              child: Text('Add or choose a bill'),
            ),
          );
        }
      },
    );
  }
}

class TwoSidedCheckableList extends StatelessWidget {
  final void Function(SharedByElement, bool) onTap;
  final List<SharedByElement> sharedBy;

  TwoSidedCheckableList({required this.sharedBy, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < sharedBy.length; i += 2)
          Row(
            children: [
              Switch(
                onChanged: (value) {
                  onTap(sharedBy[i], value);
                },
                value: sharedBy[i].settled,
              ),
              Text(sharedBy[i].friend),
              Spacer(),
              if (i + 1 < sharedBy.length) //
                Text(sharedBy[i + 1].friend),
              if (i + 1 < sharedBy.length)
                Switch(
                  onChanged: (value) {
                    onTap(sharedBy[i + 1], value);
                  },
                  value: sharedBy[i + 1].settled,
                ),
            ],
          ),
      ],
    );
  }
}
