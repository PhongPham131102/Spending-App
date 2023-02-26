import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.accountBalance,
    required this.address,
    required this.passWord,
  });

  String id;
  String fullName;
  String phone;
  String email;
  int accountBalance;
  String address;
  String passWord;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullName: json["fullName"],
        phone: json["phone"],
        email: json["email"],
        accountBalance: json["accountBalance"],
        address: json["address"],
        passWord: json["passWord"],
      );
  factory User.FromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return User(
        id: data['id'],
        fullName: data['fullName'],
        phone: data['phone'],
        email: data['email'],
        accountBalance: int.parse(data['accountBalance']),
        address: data['address'],
        passWord: data['passWord']);
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "phone": phone,
        "email": email,
        "accountBalance": accountBalance,
        "address": address,
        "passWord": passWord,
      };
}
