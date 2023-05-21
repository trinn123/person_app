import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/person_provider.dart';
import '../models/person.dart';

class AddPersonScreen extends StatefulWidget {
  @override
  _AddPersonScreenState createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String address = '';
  late String province = '';
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Person',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 1) {
            setState(() {
              _currentStep += 1;
            });
          } else {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Confirm'),
                    content: Text('Are you sure you want to add this person?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.redAccent, //
                        ),
                        onPressed: () {
                          final personProvider = Provider.of<PersonProvider>(
                              context,
                              listen: false);
                          final person = Person(
                              name: name, address: address, province: province);
                          personProvider.addPerson(person);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text('Confirm'),
                      ),
                    ],
                  );
                },
              );
            }
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          } else {
            Navigator.pop(context);
          }
        },
        steps: [
          Step(
            title: Text('Personal Information'),
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value!;
                    },
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: Text('Address'),
            content: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    address = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Province'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a province';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    province = value!;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
