class Contact {
  String? uid;
  String? name;
  String? phoneNumber;
  String? email;
  String? imageUrl;
  Contact({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.imageUrl,
    this.uid,
  });

  Contact.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    imageUrl = json['imageUrl'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['imageUrl'] = imageUrl;
    return data;
  }
}
