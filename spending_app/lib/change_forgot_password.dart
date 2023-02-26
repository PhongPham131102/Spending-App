import 'package:app_chi_tieu/signin.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";

import 'models/user.dart';

class ChangeForgotPassWordScreen extends StatefulWidget {
  String uid;
  ChangeForgotPassWordScreen({super.key, required this.uid});

  @override
  State<ChangeForgotPassWordScreen> createState() =>
      _ChangeForgotPassWordScreenState();
}

class _ChangeForgotPassWordScreenState extends State<ChangeForgotPassWordScreen>
    with CheckInPut {
  final formGlobalKey = GlobalKey<FormState>();
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  String newpassWord = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              if (formGlobalKey.currentState!.validate()) {
                final doc = FirebaseFirestore.instance
                    .collection("users")
                    .doc("${this.widget.uid}");
                doc.update({"passWord": newpassWord});
                AwesomeDialog(
                  btnOkText: "Đăng nhập ",
                  context: context,
                  animType: AnimType.topSlide,
                  headerAnimationLoop: false,
                  dialogType: DialogType.success,
                  showCloseIcon: true,
                  title: 'Thành Công',
                  desc: 'Thay Đổi Mật Khẩu thành Công',
                  descTextStyle: TextStyle(fontWeight: FontWeight.w500),
                  btnOkOnPress: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  SignIn(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ));
                  },
                  btnOkIcon: Icons.check_circle,
                ).show();
              }
            },
          ),
        ],
        backgroundColor: Colors.green,
        title: Text(
          "Thay Đổi Mật Khẩu",
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromARGB(255, 233, 233, 233),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                "Mật khẩu phải có ít nhất 8 ký tự.",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(180, 99, 97, 97)),
              ),
            ),
            Container(
                color: Color.fromARGB(255, 245, 247, 250),
                padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                child: Form(
                    key: formGlobalKey,
                    child: Column(
                      children: [
                        TextFormField(
                          obscureText: _isObscure1,
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            labelText: "Mật khẩu Mới",
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            hintText: "nhập mật khẩu mới",
                            hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                            suffixIcon: IconButton(
                                icon: Icon(
                                    _isObscure1
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey),
                                onPressed: () {
                                  setState(() {
                                    _isObscure1 = !_isObscure1;
                                  });
                                }),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(width: 0.5, color: Colors.grey),
                            ),
                          ),
                          validator: (password) {
                            if (checkpassword(password!)) {
                              newpassWord = password;
                              return null;
                            } else
                              return 'mật khẩu phải trên 8 ký tự!';
                          },
                        ),
                        TextFormField(
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            hintText: "nhập lại mật khẩu",
                            suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure2
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure2 = !_isObscure2;
                                  });
                                }),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(width: 0.5, color: Colors.grey),
                            ),
                            labelText: "Nhập lại mật khẩu",
                          ),
                          validator: (password) {
                            if (checkrepassword(password!))
                              return null;
                            else
                              return 'mật khẩu nhập lại không đúng';
                          },
                          obscureText: _isObscure2,
                        ),
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}

mixin CheckInPut {
  String? repass;

  bool checkemail(String email) {
    String pattern = r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(email);
  }

  bool checkpassword(String password) {
    String pattern = r'^\b.{7,}$';
    RegExp regex = new RegExp(pattern);
    repass = password;
    return regex.hasMatch(password);
  }

  bool checkrepassword(String password) {
    if (password == repass)
      return true;
    else
      return false;
  }
}
Future<void> _dialogBuilder(BuildContext context, String content) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Thông Báo'),
        content: Text('$content'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'đóng',
              style: TextStyle(color: Colors.green),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
