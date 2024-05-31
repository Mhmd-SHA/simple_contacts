import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../../model/contacts_model.dart';
import '../../providers/contacts_provider.dart';

class UpdateContactPage extends StatelessWidget {
  UpdateContactPage({super.key, required this.contact, required this.uid});
  Contact contact;
  String uid;
  File? _image;

  @override
  Widget build(BuildContext context) {
    print(contact.imageUrl);
    return Consumer<ContactsProvider>(
      builder: (context, provider, child) {
        provider.nameController.text = contact.name!;
        provider.emailController.text = contact.email!;
        provider.phoneNumberController.text = contact.phoneNumber!;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Update Contact"),
          ),
          body: Form(
            key: provider.formkey,
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        _image =
                            await provider.getimagefromGallery().whenComplete(
                                  () => provider.updateUi(),
                                );
                      },
                      child: CircleAvatar(
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : NetworkImage(contact.imageUrl!),
                        radius: 50,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: provider.nameController,
                      decoration: InputDecoration(
                        hintText: "Name",
                        focusColor: Colors.red,
                        fillColor: Colors.amber,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Name";
                        }
                        if (value.length < 3) {
                          return "Name shoulbe be longer than 5 characters";
                        }
                        if (value.length > 20) {
                          return "Name is longer than 20 characters";
                        }
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: provider.phoneNumberController,
                      decoration: InputDecoration(
                        hintText: "PhoneNumber",
                        focusColor: Colors.red,
                        fillColor: Colors.amber,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.length < 10 ||
                            value.isEmpty ||
                            value.contains(
                              RegExp(r'[A-Z]'),
                            )) {
                          return "Enter Valid Number";
                        }
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: provider.emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        focusColor: Colors.red,
                        fillColor: Colors.amber,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Email";
                        }
                        if (!value!.contains(
                            RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"))) {
                          return "Enter Valid Email";
                        }
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (provider.formkey.currentState!.validate()) {
                          print(provider.phoneNumberController.text.length);
                          provider
                              .updateContact(
                            uid: uid,
                            image: _image,
                            contact: Contact(
                                uid: uid,
                                name: provider.nameController.text,
                                phoneNumber:
                                    provider.phoneNumberController.text,
                                email: provider.emailController.text,
                                imageUrl: contact.imageUrl),
                          )
                              .whenComplete(
                            () {
                              Get.back();
                            },
                          );
                        }

                        // provider.addContact(
                        //   Contact(
                        //     name: provider.nameController.text,
                        //     phoneNumber: provider.phoneNumberController.text,
                        //     email: provider.emailController.text,
                        //   ),
                        // );
                      },
                      icon: Icon(MingCute.contacts_3_line),
                      label: Text(
                        "Update Contact",
                        style: TextStyle(
                          color: Colors.amber,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
