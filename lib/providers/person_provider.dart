import 'package:flutter/material.dart';
import '../models/person.dart';

class PersonProvider extends ChangeNotifier {
  List<Person> _persons = [
    Person(name: 'Jojo Eric', address: '123 yanawa', province: 'Bangkok'),
    Person(name: 'Sam Smith', address: '456 Ari', province: 'Bangkok'),
    Person(name: 'Bob Smith', address: '789', province: 'Chiang Mai'),
  ];

  List<Person> get persons => _persons;

  void addPerson(Person person) {
    _persons.add(person);
    notifyListeners();
  }

  void deletePerson(Person person) {
    _persons.remove(person);
    notifyListeners();
  }
}
