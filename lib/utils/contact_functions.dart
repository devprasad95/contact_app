import 'package:contact_app/models/contact.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../methods/db_methods.dart';
import '../services/notifications.dart';

Future<dynamic> addContactBox(
  BuildContext context, {
  required TextEditingController nameController,
  required TextEditingController phoneNumberController,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(hintText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                addContactOnClicked(
                  nameController: nameController,
                  phoneNumberController: phoneNumberController,
                );
                Notifications.showBigTextNotification(
                    title: "New contact added",
                    body:
                        '${nameController.text}\n${phoneNumberController.text}',
                    fln: flutterLocalNotificationsPlugin);
                nameController.clear();
                phoneNumberController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    },
  );
}

Future<void> addContactOnClicked({
  required TextEditingController nameController,
  required TextEditingController phoneNumberController,
}) async {
  final name = nameController.text;
  final phone = int.parse(phoneNumberController.text);
  if (name.isEmpty || phoneNumberController.text.isEmpty) {
    return;
  }
  final contactObject = Contact(name, phone);
  addContact(contactObject);
}

Future<dynamic> delete(BuildContext context, int index) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Do you want to delete this contact?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              deleteContact(index);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}

Future<dynamic> update(BuildContext context, Contact contact, int index) {
  return showDialog(
    context: context,
    builder: (context) {
      final TextEditingController updateNameController =
          TextEditingController(text: contact.name);
      final TextEditingController updatePhoneNumberController =
          TextEditingController(text: contact.phoneNumber.toString());
      return AlertDialog(
        title: const Text('Update contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: updateNameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: updatePhoneNumberController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              updateContact(
                index,
                updateNameController.text,
                int.parse(updatePhoneNumberController.text),
              );
              Navigator.of(context).pop();
            },
            child: const Text('Update'),
          ),
        ],
      );
    },
  );
}
