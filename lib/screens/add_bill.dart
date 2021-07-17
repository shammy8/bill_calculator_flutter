import 'package:flutter/material.dart';

class AddBillScreen extends StatefulWidget {
  const AddBillScreen({Key? key}) : super(key: key);

  @override
  _AddBillScreenState createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';

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
                const Text('Add new bill'),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Name'),
                  validator: (val) {
                    if (val == '') {
                      return 'Enter a name';
                    } else if (val != null && val.length > 21) {
                      return 'Description must be less than or equal to 20 letters long';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() => name = value);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Friends'),
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Editors'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print(name);
                      // StoreService().addItem(widget.bill.uid, description, cost,
                      //     paidBy, sharedBy, date);
                      // Navigator.pop(context);
                    }
                  },
                  child: const Text('Add bill'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
