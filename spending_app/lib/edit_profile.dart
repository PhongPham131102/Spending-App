import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'models/user.dart';

class EditProfileScreen extends StatefulWidget {
  User user;
  EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController fullname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  @override
  void initState() {
    fullname.text = this.widget.user.fullName;
    phone.text = this.widget.user.phone;
    address.text = this.widget.user.address;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3.2,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('img/bg.jpg'), fit: BoxFit.fill)),
                  child: Center(
                    child: Image.asset(
                      'img/user.png',
                      width: 70,
                      height: 70,
                    ),
                  ),
                ),
                Positioned(
                    top: 20,
                    left: 15,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 30,
                        )))
              ],
            ),
            Container(
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Họ và tên",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  TextField(
                    controller: fullname,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Số điện thoại",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  TextField(
                    controller: phone,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Địa chỉ",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  TextField(
                    controller: address,
                  ),
                ],
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  if (fullname.text == "" || phone.text == "") {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.topSlide,
                      headerAnimationLoop: false,
                      dialogType: DialogType.warning,
                      showCloseIcon: true,
                      title: 'Cảnh báo',
                      desc: 'Thông tin họ tên hoặc số điện thoại không được để trống.',
                      descTextStyle: TextStyle(fontWeight: FontWeight.w500),
                      btnOkOnPress: () {},
                      btnOkIcon: Icons.check_circle,
                    ).show();
                  }
                  else{
                    final doc=FirebaseFirestore.instance.collection("users").doc("${this.widget.user.id}");
                    doc.update({
                      "fullName":fullname.text,
                      "phone":phone.text,
                      "address":address.text,
                    });
                    List<dynamic> temp=[1,fullname.text,phone.text,address.text];
                    Navigator.pop(context,temp);
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 65,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.my_library_books_sharp,
                      ),
                      Text(
                        'Cập nhật',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
