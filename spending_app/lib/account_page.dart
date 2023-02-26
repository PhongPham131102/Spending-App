import 'package:app_chi_tieu/change_password.dart';
import 'package:app_chi_tieu/edit_profile.dart';
import 'package:app_chi_tieu/homescreen.dart';
import 'package:app_chi_tieu/signin.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user.dart';

class AccountPage extends StatefulWidget {
  User user;
  AccountPage({super.key, required this.user});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Future<void> set_is_logined(String value) async {
    final SharedPreferences cookie = await SharedPreferences.getInstance();
    cookie.setString('is_logined', value);
  }

  Future<void> set_id(String value) async {
    final SharedPreferences cookie = await SharedPreferences.getInstance();
    cookie.setString('id', value);
  }

  Future<void> set_account_balance(int value) async {
    final SharedPreferences cookie = await SharedPreferences.getInstance();
    cookie.setInt('ac_balance', value);
  }

  _alertChangeInfoScreen(BuildContext context, User user) async {
    dynamic result = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              EditProfileScreen(
            user: this.widget.user,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ));
    if (result != null) {
      if (result[0] == 1) {
        this.widget.user.fullName = result[1];
        this.widget.user.phone = result[2];
        this.widget.user.address = result[3];
        AwesomeDialog(
          context: context,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          showCloseIcon: true,
          title: 'Thành Công',
          desc: 'Đã thay đổi thông tin của bạn.',
          descTextStyle: TextStyle(fontWeight: FontWeight.w500),
          btnOkOnPress: () {},
          btnOkIcon: Icons.check_circle,
        ).show();
      }
      setState(() {});
    }
  }

  _alertChangePassWordScreen(BuildContext context, User user) async {
    dynamic result = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ChangePassWordScreen(
            user: this.widget.user,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ));
    if (result != null) {
      if (result[0] == 1) {
        this.widget.user.passWord = result[1];
        AwesomeDialog(
          context: context,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          showCloseIcon: true,
          title: 'Thành Công',
          desc: 'Đã thay đổi mật khẩu của bạn.',
          descTextStyle: TextStyle(fontWeight: FontWeight.w500),
          btnOkOnPress: () {},
          btnOkIcon: Icons.check_circle,
        ).show();
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Color.fromARGB(60, 216, 215, 215),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 30),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3.2,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('img/bg.jpg'), fit: BoxFit.fill)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'img/user.png',
                  width: 70,
                  height: 70,
                ),
                Text(
                  this.widget.user.fullName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                    onPressed: () {
                      _alertChangeInfoScreen(context, this.widget.user);
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Color.fromARGB(255, 210, 210, 210)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(10.0)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Colors.black),
                      )),
                    ),
                    child: Text(
                      "Chỉnh Sửa",
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    _alertChangePassWordScreen(context, this.widget.user);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Đổi mật khẩu",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    set_is_logined("");
                    set_id("");
                    set_account_balance(0);
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/Signin", (route) => false);
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(38, 244, 67, 54),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "Đăng xuất",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
