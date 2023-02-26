import 'package:app_chi_tieu/change_forgot_password.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:email_otp/email_otp.dart';

import 'models/user.dart';

class OtpScreens extends StatefulWidget {
  String email;
  String uid;
  OtpScreens({super.key, required this.email, required this.uid});

  @override
  State<OtpScreens> createState() => _OtpScreensState();
}

class _OtpScreensState extends State<OtpScreens> {
  EmailOTP myauth = EmailOTP();
  sendmain() async {
    myauth.setConfig(
        appEmail: "spendingapp@gmail.com",
        appName: "Spending App",
        userEmail: "${this.widget.email}",
        otpLength: 6,
        otpType: OTPType.digitsOnly);
    if (await myauth.sendOTP() == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text("Một mã OTP đã được gửi đến mail ${this.widget.email}"),
      ));
    }
  }

  @override
  void initState() {
    sendmain();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                  'Xác Thực Mã OTP',
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
                'Một mã otp gồm 6 chữ số đã được gửi đến địa chỉ email của bạn.',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Color.fromARGB(255, 107, 107, 107),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: OtpTextField(
                cursorColor: Colors.black,
                textStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
                autoFocus: true,
                numberOfFields: 6,
                borderColor: Colors.green,
                focusedBorderColor: Colors.black,
                fillColor: Colors.black,
                showFieldAsBox: true,
                onSubmit: (String verificationCode) async {
                  if (await myauth.verifyOTP(otp: verificationCode) == true) {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation,
                                  secondaryAnimation) =>
                              ChangeForgotPassWordScreen(uid: this.widget.uid),
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
                  } else {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.leftSlide,
                      headerAnimationLoop: false,
                      dialogType: DialogType.info,
                      showCloseIcon: true,
                      title: 'Thông Báo',
                      desc: 'mã xác thực không chính xác.',
                      descTextStyle: TextStyle(fontWeight: FontWeight.w500),
                      btnOkOnPress: () {},
                      btnOkIcon: Icons.check_circle,
                    ).show();
                  }
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
