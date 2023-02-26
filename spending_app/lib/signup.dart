import 'dart:async';

import 'package:app_chi_tieu/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'models/user.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with CheckInPut {
  List<User> users = [];
  final formGlobalKey = GlobalKey<FormState>();
  final fullName = TextEditingController();
  final passWord = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  @override
  void initState() {
    feth();
    super.initState();
  }

  feth() async {
    var records = await FirebaseFirestore.instance.collection('users').get();
    maprecords(records);
  }

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

  Future createUser({
    required String fullName,
    required String phone,
    required String email,
    required int accountBalance,
    required String address,
    required String passWord,
  }) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();
    final account = User(
        id: docUser.id,
        accountBalance: accountBalance,
        fullName: fullName,
        phone: phone,
        email: email,
        address: address,
        passWord: passWord);
    final json = account.toJson();
    await docUser.set(json);
  }

  Future<void> _dialogBuilder(BuildContext context, String content) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông Báo'),
          content: Text('$content'),
          actions: <Widget>[
            TextButton(
              child: Row(
                children: [
                  Text(
                    'Đăng nhập',
                    style: TextStyle(color: Colors.green),
                  ),
                  CountDown(),
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
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
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
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
                'Đăng Ký',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                child: Form(
                    key: formGlobalKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          controller: fullName,
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 38, 228, 44)),
                            ),
                            labelText: "Họ và tên",
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 52, 226, 57)),
                          ),
                          validator: (name) {
                            if (name!.isNotEmpty)
                              return null;
                            else
                              return 'Vui lòng nhập họ và tên.';
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          controller: phone,
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 38, 228, 44)),
                            ),
                            labelText: "Số điện thoại",
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 52, 226, 57)),
                          ),
                          validator: (phone) {
                            bool isexist = false;
                            for (var element in users) {
                              if (element.phone == phone) isexist = true;
                            }
                            if (phone == "") {
                              return "số điện thoại không được bỏ trống";
                            } else if (isexist) {
                              return 'số điện thoại đã được đăng ký';
                            } else if (checkphone(phone!))
                              return null;
                            else
                              return 'số điện thoại không đúng định dạng';
                          },
                        ),
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
                          validator: (email) {
                            bool isexist = false;
                            for (var element in users) {
                              if (element.email == email) isexist = true;
                            }
                            if (email == "") {
                              return "email không được bỏ trống";
                            } else if (isexist) {
                              return 'email đã được đăng ký';
                            } else if (checkemail(email!))
                              return null;
                            else
                              return 'email không đúng định dạng!';
                          },
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
                          validator: (password) {
                            if (password == "") {
                              return "mật khẩu không được bỏ trống";
                            } else if (checkpassword(password!))
                              return null;
                            else
                              return 'mật khẩu phải trên 8 ký tự!';
                          },
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
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
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 38, 228, 44)),
                            ),
                            labelText: "Nhập Lại Mật Khẩu",
                            labelStyle: TextStyle(
                                color: Color.fromARGB(255, 52, 226, 57)),
                          ),
                          validator: (password) {
                            if (checkrepassword(password!))
                              return null;
                            else
                              return 'mật khẩu nhập lại không đúng';
                          },
                          obscureText: _isObscure2,
                        ),
                        const SizedBox(
                          height: 25,
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
                                    fixedSize: MaterialStateProperty.all(
                                        const Size(300, 50)),
                                  ),
                                  onPressed: () {
                                    if (formGlobalKey.currentState!
                                        .validate()) {
                                      createUser(
                                          fullName: fullName.text,
                                          phone: phone.text,
                                          email: email.text,
                                          accountBalance: -1,
                                          address: "",
                                          passWord: passWord.text);
                                      feth();
                                      _dialogBuilder(
                                          context, "Đăng ký thành công.");
                                    }
                                  },
                                  child: const Text('Đăng Ký')),
                              ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(255, 255, 255, 255)),
                                    shadowColor: MaterialStateProperty.all(
                                        Color(0x000000)),
                                    fixedSize: MaterialStateProperty.all(
                                        const Size(300, 50)),
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignIn()));
                                  },
                                  child: const Text(
                                    'Đăng Nhập',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 26, 207, 32)),
                                  ))
                            ],
                          ),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

mixin CheckInPut {
  String? repass;
  bool checkphone(String phone) {
    String pattern = r'^[0-9]{10}$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(phone);
  }

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

class CountDown extends StatefulWidget {
  const CountDown({super.key});

  @override
  State<CountDown> createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  int time = 5;
  Timer? timer;
  void redirectToSignIn() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (time == 0) {
        setState(() {});
        timer.cancel();
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignIn()));
      } else {
        time--;
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    redirectToSignIn();
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(CountDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "($time)",
      style: TextStyle(color: Colors.green),
    );
  }
}
