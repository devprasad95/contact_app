import 'package:contact_app/main.dart';
import 'package:contact_app/methods/db_methods.dart';
import 'package:contact_app/models/contact.dart';
import 'package:contact_app/services/notifications.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/contact_functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _contactSearchController =
      TextEditingController();

  bool typing = false;

  @override
  void initState() {
    super.initState();
    getContact();
    Notifications.initialize(flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            setState(() {
              typing = !typing;
              _contactSearchController.clear();
            });
          },
          icon: Icon(typing ? Icons.done : Icons.search),
        ),
        title: typing
            ? Container(
                alignment: Alignment.centerLeft,
                color: Colors.white,
                child: TextField(
                  controller: _contactSearchController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      contentPadding: EdgeInsets.all(10)),
                ),
              )
            : const Text('My Contact app'),
      ),
      body: ValueListenableBuilder(
          valueListenable: contactListNotifier,
          builder: (BuildContext context, List<Contact> contactList, _) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                if (_contactSearchController.text.isEmpty) {
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
                          onPressed: () {
                            launch("tel://${contact.phoneNumber.toString()}");
                          },
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
                } else if (contactList[index]
                    .name
                    .toLowerCase()
                    .contains(_contactSearchController.text.toLowerCase())) {
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
                          onPressed: () {
                            launch("tel://${contact.phoneNumber.toString()}");
                          },
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
                } else {
                  return Container();
                }
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
