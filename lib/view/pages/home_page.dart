import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:simple_contacts/providers/contacts_provider.dart';
import 'package:simple_contacts/view/pages/add_contatcs_page.dart';
import 'package:simple_contacts/view/pages/update_contact_page.dart';

import '../../model/contacts_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactsProvider>(
      builder: (context, ContactsProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Simple Contacts".toUpperCase()),
            centerTitle: true,
          ),
          body: Center(
            child: StreamBuilder(
              stream: ContactsProvider.getContacts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List contactsList = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: contactsList.length,
                    itemBuilder: (context, index) {
                      Contact contact = contactsList[index].data();
                      String Uid = contactsList[index].id;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(contact.imageUrl!),
                        ),
                        title: Text(
                          contact.name.toString(),
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                            maxLines: 3,
                            "${contact.phoneNumber.toString()}\n${contact.email.toString()} "),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.to(() => UpdateContactPage(
                                        contact: contact,
                                        uid: Uid,
                                      ));
                                },
                                icon: Icon(MingCute.pencil_2_fill),
                              ),
                              IconButton(
                                onPressed: () {
                                  ContactsProvider.deleteContact(
                                      uid: Uid, FilePath: contact.imageUrl!);
                                },
                                icon: Icon(
                                  MingCute.delete_2_fill,
                                  color: Colors.redAccent.shade200,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              ContactsProvider.clearFields();
              Get.to(
                () => AddContactPage(),
                transition: Transition.cupertino,
              );
            },
            icon: Icon(MingCute.contacts_2_fill),
            label: Text("Add Contacts"),
          ),
        );
      },
    );
  }
}
