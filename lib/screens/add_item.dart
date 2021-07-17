import 'package:flutter/material.dart';
import 'package:bill_calculator_flutter/services/models.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:bill_calculator_flutter/services/services.dart';

class AddItemScreen extends StatefulWidget {
  final Bill bill;
  const AddItemScreen({required this.bill});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();

  String description = '';
  num cost = 0.0;
  String paidBy = '';
  List sharedBy = [];
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const CircleAvatar(
                  minRadius: 100,
                  backgroundImage: NetworkImage(
                      'https://thumbs-prod.si-cdn.com/6MmkyNmsODbteKNYiAMz6201KOw=/800x600/filters:no_upscale():focal(2062x722:2063x723)/https://public-media.si-cdn.com/filer/20/85/2085a351-1759-4b7e-bb3e-eadec17b7aef/papageitaucher_fratercula_arctica.jpg'),
                ),
                Text('Add item to ${widget.bill.name}'),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Description'),
                  validator: (val) {
                    if (val == '') {
                      return 'Enter a description';
                    } else if (val != null && val.length > 26) {
                      return 'Description must be less than or equal to 25 letters long';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() => description = value);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Cost'),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null) return 'Error';
                    final number = double.parse(val);
                    //TODO must only be 2 decimal places
                    return number < 0 ? 'Cost must be a positive number' : null;
                  },
                  onChanged: (value) {
                    final number = double.parse(value);
                    setState(() => cost = number);
                  },
                ),
                PaidByDropDownInput(
                  friends: widget.bill.friends,
                  onChanged: (value) {
                    setState(() {
                      paidBy = value;
                    });
                  },
                ),
                MultiSelectFormField(
                  title: const Text(
                    'Shared by',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 17,
                    ),
                  ),
                  dataSource: widget.bill.friends.map((friend) {
                    return {"value": friend, "display": friend};
                  }).toList(),
                  textField: 'display',
                  valueField: 'value',
                  hintWidget: const Text(''),
                  initialValue: const [],
                  validator: (values) {
                    if (values == null || values.length == 0) {
                      return 'Please select at least one friend';
                    }
                    return null;
                  },
                  onSaved: (values) {
                    if (values == null) return;
                    setState(() {
                      sharedBy =
                          values as List<dynamic>; //TODO should be List<String>
                    });
                  },
                ),
                InputDatePickerFormField(
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2010),
                  lastDate: DateTime(2050),
                  fieldHintText: 'Date',
                  onDateSubmitted: (value) {
                    setState(() {
                      date = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      StoreService().addItem(widget.bill.uid, description, cost,
                          paidBy, sharedBy, date);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add item'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaidByDropDownInput extends StatelessWidget {
  const PaidByDropDownInput({
    Key? key,
    required this.friends,
    required this.onChanged,
  }) : super(key: key);

  final List<String> friends;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      onChanged: (value) {
        if (value != null) onChanged(value as String);
      },
      validator: (val) {
        // TODO pass validator in from the outside??
        return val == null ? 'Please select the payer' : null;
      },
      isExpanded: true,
      hint: const Text('Paid by'),
      items: friends
          .map(
            (friend) => DropdownMenuItem(
              value: friend,
              child: Text(friend),
            ),
          )
          .toList(),
    );
  }
}
