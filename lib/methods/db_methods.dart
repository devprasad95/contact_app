import 'package:contact_app/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

ValueNotifier<List<Contact>> contactListNotifier = ValueNotifier([]);

addContact(Contact value) async {
  final contactDb = await Hive.openBox<Contact>('contact');
  await contactDb.add(value);
  getContact();
}

getContact() async {
  final contactDb = await Hive.openBox<Contact>('contact');
  contactListNotifier.value.clear();
  contactListNotifier.value.addAll(contactDb.values);
  contactListNotifier.notifyListeners();
}

deleteContact(int index) async {
  final contactDb = await Hive.openBox<Contact>('contact');
  contactDb.deleteAt(index);
  getContact();
}

updateContact(int index, String name, int phoneNumber) async {
  final contactDb = await Hive.openBox<Contact>('contact');
  contactDb.putAt(
    index,
    Contact(name, phoneNumber),
  );
  getContact();
}
