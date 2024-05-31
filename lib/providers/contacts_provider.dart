import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../model/contacts_model.dart';

class ContactsProvider extends ChangeNotifier {
  ContactsProvider() {
    clearFields();
  }

  Uuid _uid = Uuid();
  Uuid get uuid => _uid;
  List<Contact> _contacts = [];
  List<Contact> get contacts => _contacts;

  final formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  final ImagePicker _picker = ImagePicker();

  Future<void> addContact({required Contact contact, File? image}) async {
    startLoader();
    String docId = uuid.v4();
    if (image != null) {
      final StoragereRef = firebaseStorage
          .ref('Contacts/profile')
          .child('${docId}${path.extension(image.path)}');

      final UploadTask uploadTask = StoragereRef.putFile(image);
      await uploadTask.whenComplete(
        () async {
          contact.imageUrl = await StoragereRef.getDownloadURL();
        },
      );
    }

    await firebaseFirestore.collection("Contacts").doc(docId).set(Contact(
            name: contact.name,
            phoneNumber: contact.phoneNumber,
            email: contact.email,
            imageUrl: contact.imageUrl,
            uid: docId)
        .toJson());
    stopLoader();
    notifyListeners();
  }

  Future<void> updateContact(
      {required String uid, required Contact contact, File? image}) async {
    startLoader();
    if (image != null) {
      final StoragereRef = firebaseStorage
          .ref('Contacts/profile')
          .child('${uid}${path.extension(image.path)}');

      final UploadTask uploadTask = StoragereRef.putFile(image);
      await uploadTask.whenComplete(
        () async {
          contact.imageUrl = await StoragereRef.getDownloadURL();
        },
      );
    }
    await firebaseFirestore.collection("Contacts").doc(uid).update(Contact(
          name: contact.name,
          phoneNumber: contact.phoneNumber,
          email: contact.email,
          imageUrl: contact.imageUrl,
          uid: uid,
        ).toJson());

    stopLoader();
    notifyListeners();
  }

  Future<void> deleteContact(
      {required String uid, required String FilePath}) async {
    try {
      await firebaseFirestore.collection("Contacts").doc(uid).delete();
      final StoragereRef = await firebaseStorage
          .ref('Contacts/profile')
          .child("$uid.jpg")
          .delete();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Stream<QuerySnapshot> getContacts() {
    return firebaseFirestore
        .collection("Contacts")
        .withConverter<Contact>(
          fromFirestore: (snapshot, _) => Contact.fromJson(snapshot.data()!),
          toFirestore: (todo, _) => todo.toJson(),
        )
        .orderBy('name')
        .snapshots();
  }

  Future<File?> getimagefromGallery() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      return File(file.path);
    }

    return null;
  }

  void clearFields() {
    nameController.clear();
    phoneNumberController.clear();
    emailController.clear();
  }

  void startLoader() {
    Get.dialog(PopScope(
      canPop: false,
      child: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    ));
  }

  void stopLoader() {
    Get.back();
  }

  updateUi() {
    notifyListeners();
  }
}
