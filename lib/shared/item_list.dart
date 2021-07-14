import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:bill_calculator_flutter/services/services.dart';
import 'package:bill_calculator_flutter/services/models.dart';

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
