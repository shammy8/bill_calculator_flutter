import 'package:intl/intl.dart';
// import 'package:bill_calculator_flutter/shared/items.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bill_calculator_flutter/services/services.dart';
import 'package:bill_calculator_flutter/shared/drawer.dart';
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

    return MultiProvider(
      providers: [
        StreamProvider<List<Bill>>.value(
          value: StoreService().getAllBills(user!.uid),
          initialData: const [],
        ),
        StreamProvider<List<Item>>.value(
          value: StoreService().getAllItems(billId),
          initialData: const [],
        ),
      ],
      builder: (context, child) {
        final List<Bill> bills = context.watch<List<Bill>>();
        final items = context.watch<List<Item>>();
        if (billId != 'empty') {
          final Bill bill = bills.firstWhere((bill) => bill.uid == billId);
          return Scaffold(
            endDrawer: BillDrawer(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
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
                ItemList(items: items, billId: bill.uid)
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(),
            endDrawer: BillDrawer(),
            body: const Center(
              child: Text('Add or choose a bill'),
            ),
          );
        }
      },
    );
  }
}

class ItemList extends StatelessWidget {
  final List<Item> items;
  final String billId;
  final oCcy = NumberFormat("#,##0.00", "en_US");

  ItemList({required this.items, required this.billId});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final Item item = items[index];
            List<SharedByElement> sharedBy = item.sharedBy;

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.description,
                        style: Theme.of(context).textTheme.headline6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(oCcy.format(item.cost),
                            style: Theme.of(context).textTheme.headline6),
                        paidBySpan(context, item.paidBy),
                      ],
                    ),
                  ],
                ),
                TwoSidedCheckableList(
                  sharedBy: item.sharedBy,
                  onTap: (sharedByElement, newValue) {
                    // print(sharedByElement);
                    sharedBy = sharedBy.map((element) {
                      if (sharedByElement.friend == element.friend) {
                        return SharedByElement.fromMap({
                          'friend': sharedByElement.friend,
                          'settled': newValue
                        });
                      } else {
                        return element;
                      }
                    }).toList();
                    StoreService().updateItem(sharedBy, item.id, billId);
                  },
                ),
                const Divider(),
              ],
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }

  RichText paidBySpan(BuildContext context, String payer) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyText1,
        text: "paid by ",
        children: [
          TextSpan(
            style: const TextStyle(fontWeight: FontWeight.w900),
            text: payer,
          ),
        ],
      ),
    );
  }
}

class TwoSidedCheckableList extends StatelessWidget {
  final void Function(SharedByElement, bool) onTap;
  final List<SharedByElement> sharedBy;

  const TwoSidedCheckableList({required this.sharedBy, required this.onTap});

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
              const Spacer(),
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
