import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:simple_contacts/model/contacts_model.dart';
import 'package:simple_contacts/providers/contacts_provider.dart';

class AddContactPage extends StatelessWidget {
  AddContactPage({super.key});

  File? _image;

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactsProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text("Add Contact"),
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
                        radius: 50,
                        backgroundImage:
                            _image != null ? FileImage(_image!) : null,
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
                      maxLength: 20,
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
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "PhoneNumber",
                        focusColor: Colors.red,
                        fillColor: Colors.amber,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      maxLength: 10,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                      maxLength: 40,
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
                              .addContact(
                            contact: Contact(
                              name: provider.nameController.text,
                              phoneNumber: provider.phoneNumberController.text,
                              email: provider.emailController.text,
                              imageUrl: "",
                            ),
                            image: _image,
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
                        "Add Contact",
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
