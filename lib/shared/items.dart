import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bill_calculator_flutter/services/models.dart';

class Items extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = context.watch<List<Item>>();

    return Column(
      children: items
          .map((item) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        item.description,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item.cost.toString(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text('paid by ${item.paidBy}'),
                      // Text(item.date.toString()),
                    ],
                  ),
                ],
              ))
          .toList(),
    );
  }
}
