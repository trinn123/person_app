import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/person_provider.dart';
import '../models/person.dart';
import 'add_person_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Person App',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          bottom: TabBar(
            unselectedLabelColor: Colors.redAccent,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.redAccent),
            tabs: [
              Tab(
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.redAccent, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("All"),
                    )),
              ),
              Tab(
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.redAccent, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('By Province'),
                    )),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AllPersonsTab(),
            ByProvinceTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPersonScreen(),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class AllPersonsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final personProvider = Provider.of<PersonProvider>(context);
    final List<Person> persons = personProvider.persons;

    return ListView.builder(
      itemCount: persons.length,
      itemBuilder: (context, index) {
        final person = persons[index];
        return ListTile(
          title: Text(person.name),
          subtitle: Text(person.address),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Confirm Delete'),
                    content:
                        Text('Are you sure you want to delete this person?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          personProvider.deletePerson(person);
                          Navigator.pop(context);
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class ByProvinceTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final personProvider = Provider.of<PersonProvider>(context);
    final List<Person> persons = personProvider.persons;

    Map<String, List<Person>> personsByProvince = {};
    for (Person person in persons) {
      if (!personsByProvince.containsKey(person.province)) {
        personsByProvince[person.province] = [];
      }
      personsByProvince[person.province]!.add(person);
    }

    return ListView.builder(
      itemCount: personsByProvince.length,
      itemBuilder: (context, index) {
        final province = personsByProvince.keys.elementAt(index);
        final provincePersons = personsByProvince[province]!;
        return ExpansionTile(
          title: Text(province),
          children: provincePersons.map((person) {
            return ListTile(
              title: Text(person.name),
              subtitle: Text(person.address),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Confirm Delete'),
                        content: Text(
                            'Are you sure you want to delete this person?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              personProvider.deletePerson(person);
                              Navigator.pop(context);
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
