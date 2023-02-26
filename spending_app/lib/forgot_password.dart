import 'package:app_chi_tieu/cornfirm_otp.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:email_otp/email_otp.dart';

import 'models/user.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    Stream<List<User>> fetchUsers() => FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
    TextEditingController mailcontroller = TextEditingController();
    return Scaffold(
      body: StreamBuilder(
        stream: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return AlertDialog(
              title: const Text('Thông Báo'),
              content: Text('Lỗi server.\n Mã lỗi :${snapshot.error}'),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'đóng',
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          else if (snapshot.hasData) {
            List<User> user = snapshot.data!;
            return Container(
              padding: EdgeInsets.only(top: 30),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width / 6),
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back_outlined))),
                      Text(
                        'Quên Mật Khẩu',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 100, 0),
                    child: Text(
                      'Nhập địa chỉ email đăng ký để chúng tôi gửi email hướng dẫn cách lấy lại mật khẩu.',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Color.fromARGB(255, 107, 107, 107),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: TextFormField(
                      controller: mailcontroller,
                      cursorColor: Colors.green,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 2,
                              color: Color.fromARGB(255, 38, 228, 44)),
                        ),
                        labelText: "Email",
                        labelStyle:
                            TextStyle(color: Color.fromARGB(255, 52, 226, 57)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 26, 207, 32)),
                            fixedSize:
                                MaterialStateProperty.all(const Size(100, 50)),
                          ),
                          onPressed: () {
                            bool exits = false;
                            String uid = "";
                            for (var element in user) {
                              if (mailcontroller.text == element.email) {
                                exits = true;
                                uid = element.id;
                              }
                            }
                            if (exits == false) {
                              AwesomeDialog(
                                context: context,
                                animType: AnimType.leftSlide,
                                headerAnimationLoop: false,
                                dialogType: DialogType.warning,
                                showCloseIcon: true,
                                title: 'Thông Báo',
                                desc: 'email không tồn tại trong hệ thống.',
                                descTextStyle:
                                    TextStyle(fontWeight: FontWeight.w500),
                                btnOkOnPress: () {},
                                btnOkIcon: Icons.check_circle,
                              ).show();
                            } else {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        OtpScreens(
                                            email: mailcontroller.text,
                                            uid: uid),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1.0, 0.0),
                                          end: Offset.zero,
                                        ).animate(animation),
                                        child: child,
                                      );
                                    },
                                  ));
                            }
                          },
                          child: const Text('Gửi')),
                    ],
                  )
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
