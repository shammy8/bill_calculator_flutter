import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:bill_calculator_flutter/services/services.dart';

class AddBillScreen extends StatefulWidget {
  const AddBillScreen({Key? key}) : super(key: key);

  @override
  _AddBillScreenState createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  List<String> friends = [];
  List<String> editors = [];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
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
                const SizedBox(height: 20),
                // TODO neet to style, add validation and other stuff for these textfieldtags
                TextFieldTags(
                  tagsStyler: TagsStyler(
                    // tagTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    tagDecoration: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    tagCancelIcon:
                        Icon(Icons.cancel, size: 18.0, color: Colors.black),
                    tagPadding: const EdgeInsets.all(6.0),
                  ),
                  textFieldStyler: TextFieldStyler(
                    helperText: '',
                    hintText: 'Name of friends',
                    textFieldEnabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.none),
                    ),
                  ),
                  onTag: (val) {
                    friends.add(val);
                  },
                  onDelete: (val) {
                    // TODO this doesn't get called when validation stops a tag from being added
                    friends.remove(val);
                  },
                  validator: (tag) {
                    if (tag != null && tag.length > 15) {
                      return "hey that's too long";
                    }
                    return null;
                  },
                ),
                TextFieldTags(
                  tagsStyler: TagsStyler(
                    // tagTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    tagDecoration: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    tagCancelIcon: const Icon(Icons.cancel,
                        size: 18.0, color: Colors.black),
                    tagPadding: const EdgeInsets.all(6.0),
                  ),
                  textFieldStyler: TextFieldStyler(
                    helperText: '',
                    hintText: 'UID of editors',
                    textFieldEnabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.none),
                    ),
                  ),
                  onTag: (val) {
                    editors.add(val);
                  },
                  onDelete: (val) {
                    editors.remove(val);
                  },
                  validator: (tag) {
                    if (tag != null && tag.length > 30) {
                      return "hey that's too long";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      StoreService().addBill(user!.uid, name, friends, editors);
                      Navigator.pop(context); // TODO nav to new bill
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
