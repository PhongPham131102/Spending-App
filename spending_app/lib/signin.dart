import 'package:app_chi_tieu/first_login.dart';
import 'package:app_chi_tieu/forgot_password.dart';
import 'package:app_chi_tieu/homescreen.dart';
import 'package:app_chi_tieu/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/dialog.dart';
import 'models/user.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with CheckInPut {
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

  List<User> users = [];
  maprecords(QuerySnapshot<Map<String, dynamic>> records) {
    var _list = records.docs
        .map((e) => User(
              id: e['id'],
              fullName: e['fullName'],
              phone: e['phone'],
              email: e['email'],
              accountBalance: e['accountBalance'],
              address: e['address'],
              passWord: e['passWord'],
            ))
        .toList();
    users = _list;
  }

  final passWord = TextEditingController();
  final email = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  @override
  Widget build(BuildContext context) {
    Stream<List<User>> fetchUsers() => FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
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
          final _users = snapshot.data!;
          users = _users;
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: 40),
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_outlined)))
                  ],
                ),
                Text(
                  'Đăng Nhập',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                  child: Form(
                      child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: email,
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 38, 228, 44)),
                          ),
                          labelText: "Email",
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 52, 226, 57)),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: passWord,
                        obscureText: _isObscure1,
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
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
                            borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 38, 228, 44)),
                          ),
                          labelText: "Mật Khẩu",
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 52, 226, 57)),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  )),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 26, 207, 32)),
                            fixedSize:
                                MaterialStateProperty.all(const Size(300, 50)),
                          ),
                          onPressed: () {
                            bool isexist = false;
                            int _accountBalance = 0;
                            String uid = "";
                            for (var element in users) {
                              print(element.id);
                              if (element.email == email.text &&
                                  element.passWord == passWord.text) {
                                uid = element.id;
                                _accountBalance = element.accountBalance;
                                print(element.accountBalance);
                                print(_accountBalance);
                                set_is_logined('1');
                                set_id(element.id);
                                set_account_balance(element.accountBalance);
                                isexist = true;
                              }
                            }
                            if (isexist == false) {
                              dialogBuilder(context,
                                  "Email hoặc mật khẩu không đúng.");
                            } else if (_accountBalance == -1) {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        First_Login(
                                      uid: uid,
                                    ),
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
                            } else if (isexist == true) {
                              Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        HomeScreen(
                                      uid: uid,
                                    ),
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
                            } else {
                              dialogBuilder(context, "Lỗi kết nối mạng");
                            }
                          },
                          child: const Text('Đăng Nhập')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromARGB(0, 255, 255, 255)),
                                shadowColor:
                                    MaterialStateProperty.all(Color(0x000000)),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          SignUp(),
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
                              },
                              child: const Text(
                                textAlign: TextAlign.start,
                                'Đăng Ký',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 26, 207, 32)),
                              )),
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromARGB(0, 255, 255, 255)),
                                shadowColor:
                                    MaterialStateProperty.all(Color(0x000000)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        const ForgotPassword(),
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
                                  ),
                                );
                              },
                              child: const Text(
                                'Quên Mật Khẩu',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 26, 207, 32)),
                              )),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        } else
          return Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
      },
    ));
  }
}
