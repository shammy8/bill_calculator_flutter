import 'package:flutter/material.dart';
import 'package:bill_calculator_flutter/services/models.dart';

class AddItemScreen extends StatelessWidget {
  final Bill bill;
  const AddItemScreen({required this.bill});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const CircleAvatar(
                  minRadius: 100,
                  backgroundImage: NetworkImage(
                      'https://thumbs-prod.si-cdn.com/6MmkyNmsODbteKNYiAMz6201KOw=/800x600/filters:no_upscale():focal(2062x722:2063x723)/https://public-media.si-cdn.com/filer/20/85/2085a351-1759-4b7e-bb3e-eadec17b7aef/papageitaucher_fratercula_arctica.jpg'),
                ),
                Text('Add item to ${bill.name}'),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Description'),
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Cost'),
                  keyboardType: TextInputType.number,
                ),
                PaidByDropDown(bill: bill),
                InputDatePickerFormField(
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2010),
                  lastDate: DateTime(2050),
                  fieldHintText: 'Date',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaidByDropDown extends StatelessWidget {
  const PaidByDropDown({
    Key? key,
    required this.bill,
  }) : super(key: key);

  final Bill bill;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        onChanged: (value) {
          print(value);
        },
        isExpanded: true,
        hint: const Text('Paid By'),
        items: bill.friends
            .map((friend) => DropdownMenuItem(
                  value: friend,
                  child: Text(friend),
                ))
            .toList());
  }
}
