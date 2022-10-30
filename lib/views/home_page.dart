import 'package:contact_app/methods/db_methods.dart';
import 'package:contact_app/models/contact.dart';
import 'package:flutter/material.dart';

import '../utils/contact_functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getContact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Contact app'),
      ),
      body: ValueListenableBuilder(
          valueListenable: contactListNotifier,
          builder: (BuildContext context, List<Contact> contactList, _) {
            return ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(contact.name),
                  subtitle: Text(contact.phoneNumber.toString()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.call),
                      ),
                      IconButton(
                        onPressed: () {
                          delete(context, index);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                      IconButton(
                        onPressed: () {
                          update(context, contact, index);
                        },
                        icon: const Icon(Icons.update),
                      )
                    ],
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addContactBox(
            context,
            nameController: _nameController,
            phoneNumberController: _phoneNumberController,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  
}
