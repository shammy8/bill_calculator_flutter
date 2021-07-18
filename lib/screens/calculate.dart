import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bill_calculator_flutter/services/models.dart';

class CalculateScreen extends StatelessWidget {
  final Bill bill;
  final List<Item> items;
  final oCcy = NumberFormat("#,##0.00", "en_US");

  CalculateScreen({required this.bill, required this.items, Key? key})
      : super(key: key);

  Map<String, dynamic> calculate(List<Item> items) {
    final Map<String, dynamic> ledger =
        createMapWithEveryone(createMapWithEveryone<num>(0));
    for (final item in items) {
      for (final sharedByElement in item.sharedBy) {
        ledger[item.paidBy][sharedByElement.friend] +=
            sharedByElement.settled == true
                ? 0
                : item.cost / item.sharedBy.length;

        ledger[sharedByElement.friend][item.paidBy] -=
            sharedByElement.settled == true
                ? 0
                : item.cost / item.sharedBy.length;
      }
    }
    return ledger;
  }

  Map<String, T> createMapWithEveryone<T>(T value) {
    final Map<String, T> map = {};
    for (final friend in bill.friends) {
      if (value is Map && value != null) {
        map[friend] = {...value} as T;
      } else {
        map[friend] = value;
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final calculatedLedger = calculate(items);

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: Column(
          children: [
            const CircleAvatar(
              minRadius: 100,
              backgroundImage: NetworkImage(
                  'https://thumbs-prod.si-cdn.com/6MmkyNmsODbteKNYiAMz6201KOw=/800x600/filters:no_upscale():focal(2062x722:2063x723)/https://public-media.si-cdn.com/filer/20/85/2085a351-1759-4b7e-bb3e-eadec17b7aef/papageitaucher_fratercula_arctica.jpg'),
            ),
            const SizedBox(height: 30),
            Text(
              'Calculate',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 20),
            for (var friend1 in calculatedLedger.keys)
              for (var friend2 in calculatedLedger[friend1].keys)
                if (calculatedLedger[friend1][friend2] as num < 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(friend1,
                              style: Theme.of(context).textTheme.subtitle1),
                        ),
                        const Expanded(child: Text('owes')),
                        Expanded(
                          child: Text('$friend2',
                              style: Theme.of(context).textTheme.subtitle1),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                oCcy.format(
                                    calculatedLedger[friend1][friend2] * -1),
                                style: Theme.of(context).textTheme.subtitle1),
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
