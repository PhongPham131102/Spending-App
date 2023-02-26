import 'dart:async';
import 'package:app_chi_tieu/functions/caculator.dart';
import 'package:app_chi_tieu/homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class First_Login extends StatefulWidget {
  String uid;
   First_Login({super.key,required this.uid});

  @override
  State<First_Login> createState() => _First_LoginState();
}

class _First_LoginState extends State<First_Login> {
  bool showCalculator = true;
  String Sign = "";
  var formatter = NumberFormat('#,###,000');
  String? showMoney;
  String? money;
  String money1 = "";
  bool isNegative = false;
  @override
  void initState() {
    money = "0";
    updateMoney(money!);
    setState(() {});
    super.initState();
  }

  updateMoney(String money) {
    if (num.tryParse(money) == null) {
      showMoney = money;
    } else if (int.parse(money) > 999) {
      showMoney = formatter.format(int.parse(money));
    } else if (int.parse(money) < 0) {
      isNegative = true;
      showMoney = "0";
      Timer(Duration(seconds: 5), () {
        isNegative = false;
        setState(() {});
      });
    } else {
      showMoney = money;
    }
  }

  String FormatMoney(String money) {
    String temp;
    if (num.tryParse(money) == null) {
      temp = money;
    } else if (int.parse(money) > 999) {
      temp = formatter.format(int.parse(money));
    } else {
      temp = money;
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        showCalculator = false;
        if (Sign != "" && money1 != "") {
          money = money!.replaceAll(',', '');
          int a = int.parse(money!);
          money1 = money1.replaceAll(',', '');
          int b = int.parse(money1);
          dynamic c;
          switch (Sign) {
            case "+":
              c = a + b;
              break;
            case "-":
              c = a - b;
              break;
            case "x":
              c = a * b;
              break;
            case "/":
              c = a / b;
              break;
            default:
          }
          if (c is double) {
            c = c.toInt();
          }
          updateMoney(c.toString());
          money1 = "";
          Sign = "";
          setState(() {});
        } else {
          if (Sign != "") {
            showMoney = showMoney!.substring(0, showMoney!.length - 1);
            Sign = "";
          }

          showCalculator = false;
          setState(() {});
        }
        setState(() {});
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 80),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Bắt đầu sử dụng với ",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "Số Dư",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    "mà bạn hiện có trong ví hoặc tài khoản?",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                  ),
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: TextButton(
                              onPressed: () {
                                showCalculator = true;
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                setState(() {});
                              },
                              child: Text(
                                showMoney!,
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text('đ',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 0, 0, 0))),
                          )
                        ],
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width - 80,
                        color: Colors.black,
                      ),
                      isNegative
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                                  child: Text(
                                    showMoney!.length > 14
                                        ? "Số tiền quá lớn vui lòng thử lại"
                                        : 'Số tiền không được âm.',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            )
                          : Container(),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
                bottom: showCalculator ? 262 : 10,
                left: MediaQuery.of(context).size.width / 2 - 125,
                child: TextButton(
                  onPressed: () {
                    if (Sign != "" && money1 != "") {
                      money = money!.replaceAll(',', '');
                      int a = int.parse(money!);
                      money1 = money1.replaceAll(',', '');
                      int b = int.parse(money1);
                      dynamic c;
                      switch (Sign) {
                        case "+":
                          c = a + b;
                          break;
                        case "-":
                          c = a - b;
                          break;
                        case "x":
                          c = a * b;
                          break;
                        case "/":
                          c = a / b;
                          break;
                        default:
                      }
                      if (c is double) {
                        c = c.toInt();
                      }
                      updateMoney(c.toString());
                      money1 = "";
                      Sign = "";
                      setState(() {});
                    } else {
                      if (Sign != "") {
                        showMoney =
                            showMoney!.substring(0, showMoney!.length - 1);
                        Sign = "";
                      }

                      showCalculator = false;
                      setState(() {});
                    }
                    setState(() {});
                     final doc = FirebaseFirestore.instance
                        .collection('users')
                        .doc("${this.widget.uid}");
                    dynamic accountBalance = showMoney!.replaceAll(",", "");
                    accountBalance=int.parse(accountBalance);
                    doc.update({'accountBalance': accountBalance});
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(uid: this.widget.uid),), (route) => false);
                  },
                  child: Container(
                    width: 250,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Center(
                      child: Text(
                        "Bắt Đầu Thôi!",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )),
            showCalculator
                ? Positioned(
                    bottom: 0,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (showMoney!.length > 14) {
                                    isNegative = true;
                                    setState(() {});
                                    Timer(Duration(seconds: 3), () {
                                      isNegative = false;
                                      setState(() {});
                                    });
                                  } else {
                                    int result = CheckSignPlus(showMoney!);
                                    if (Sign != "" && money1 != "") {
                                      money = money!.replaceAll(',', '');
                                      int a = int.parse(money!);
                                      money1 = money1.replaceAll(',', '');
                                      int b = int.parse(money1);
                                      dynamic c;
                                      switch (Sign) {
                                        case "+":
                                          c = a + b;
                                          break;
                                        case "-":
                                          c = a - b;
                                          break;
                                        case "x":
                                          c = a * b;
                                          break;
                                        case "/":
                                          c = a / b;
                                          break;
                                        default:
                                      }
                                      if (c is double) {
                                        c = c.toInt();
                                      }
                                      updateMoney(c.toString());
                                      money1 = "";
                                      Sign = "";
                                      setState(() {});
                                    }
                                    if (result == 1) {
                                      Sign = "+";
                                      showMoney = showMoney! + "+";
                                    } else if (result == 2) {
                                      Sign = "+";
                                      showMoney = showMoney!
                                          .substring(0, showMoney!.length - 1);
                                      showMoney = showMoney! + "+";
                                    }
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 230, 233, 237),
                                    border: Border(
                                      right: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                      bottom: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '+',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (showMoney!.length > 14) {
                                    isNegative = true;
                                    setState(() {});
                                    Timer(Duration(seconds: 3), () {
                                      isNegative = false;
                                      setState(() {});
                                    });
                                  } else {
                                    int result = CheckSignSubtract(showMoney!);
                                    if (Sign != "" && money1 != "") {
                                      money = money!.replaceAll(',', '');
                                      int a = int.parse(money!);
                                      money1 = money1.replaceAll(',', '');
                                      int b = int.parse(money1);
                                      dynamic c;
                                      switch (Sign) {
                                        case "+":
                                          c = a + b;
                                          break;
                                        case "-":
                                          c = a - b;
                                          break;
                                        case "x":
                                          c = a * b;
                                          break;
                                        case "/":
                                          c = a / b;
                                          break;
                                        default:
                                      }
                                      if (c is double) {
                                        c = c.toInt();
                                      }
                                      updateMoney(c.toString());
                                      money1 = "";
                                      Sign = "";
                                      setState(() {});
                                    }
                                    if (result == 1) {
                                      Sign = "-";
                                      showMoney = showMoney! + "-";
                                    } else if (result == 2) {
                                      Sign = "-";
                                      showMoney = showMoney!
                                          .substring(0, showMoney!.length - 1);
                                      showMoney = showMoney! + "-";
                                    }
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 230, 233, 237),
                                    border: Border(
                                      right: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                      bottom: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '-',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (showMoney!.length > 14) {
                                    isNegative = true;
                                    setState(() {});
                                    Timer(Duration(seconds: 3), () {
                                      isNegative = false;
                                      setState(() {});
                                    });
                                  } else {
                                    int result = CheckSignMutiple(showMoney!);
                                    if (Sign != "" && money1 != "") {
                                      money = money!.replaceAll(',', '');
                                      int a = int.parse(money!);
                                      money1 = money1.replaceAll(',', '');
                                      int b = int.parse(money1);
                                      dynamic c;
                                      switch (Sign) {
                                        case "+":
                                          c = a + b;
                                          break;
                                        case "-":
                                          c = a - b;
                                          break;
                                        case "x":
                                          c = a * b;
                                          break;
                                        case "/":
                                          c = a / b;
                                          break;
                                        default:
                                      }
                                      if (c is double) {
                                        c = c.toInt();
                                      }
                                      updateMoney(c.toString());
                                      money1 = "";
                                      Sign = "";
                                      setState(() {});
                                    }
                                    if (result == 1) {
                                      Sign = "x";
                                      showMoney = showMoney! + "x";
                                    } else if (result == 2) {
                                      Sign = "x";
                                      showMoney = showMoney!
                                          .substring(0, showMoney!.length - 1);
                                      showMoney = showMoney! + "x";
                                    }
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 230, 233, 237),
                                    border: Border(
                                      right: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                      bottom: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'x',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (showMoney!.length > 14) {
                                    isNegative = true;
                                    setState(() {});
                                    Timer(Duration(seconds: 3), () {
                                      isNegative = false;
                                      setState(() {});
                                    });
                                  } else {
                                    int result = CheckSignDevide(showMoney!);
                                    if (Sign != "" && money1 != "") {
                                      money = money!.replaceAll(',', '');
                                      int a = int.parse(money!);
                                      money1 = money1.replaceAll(',', '');
                                      int b = int.parse(money1);
                                      dynamic c;
                                      switch (Sign) {
                                        case "+":
                                          c = a + b;
                                          break;
                                        case "-":
                                          c = a - b;
                                          break;
                                        case "x":
                                          c = a * b;
                                          break;
                                        case "/":
                                          c = a / b;
                                          break;
                                        default:
                                      }
                                      if (c is double) {
                                        c = c.toInt();
                                      }
                                      updateMoney(c.toString());
                                      money1 = "";
                                      Sign = "";
                                      setState(() {});
                                    }
                                    if (result == 1) {
                                      Sign = "/";
                                      showMoney = showMoney! + "/";
                                    } else if (result == 2) {
                                      Sign = "/";
                                      showMoney = showMoney!
                                          .substring(0, showMoney!.length - 1);
                                      showMoney = showMoney! + "/";
                                    }
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 230, 233, 237),
                                    border: Border(
                                      right: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                      bottom: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '/',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (showMoney!.length > 14) {
                                    isNegative = true;
                                    setState(() {});
                                    Timer(Duration(seconds: 3), () {
                                      isNegative = false;
                                      setState(() {});
                                    });
                                  } else {
                                    if (showMoney == "0") {
                                      showMoney = "1";
                                    } else if (Sign == "") {
                                      showMoney = showMoney! + "1";
                                      money = showMoney!.replaceAll(",", "");
                                      updateMoney(money!);
                                    } else if (Sign != "") {
                                      showMoney = showMoney! + "1";
                                      money = showMoney!.substring(
                                          0, showMoney!.indexOf(Sign));
                                      money1 = showMoney!.substring(
                                          showMoney!.indexOf(Sign) + 1);
                                      money1 = money1.replaceAll(",", "");
                                      money1 = FormatMoney(money1);
                                      switch (Sign) {
                                        case "+":
                                          showMoney = money! + "+" + money1;
                                          break;
                                        case "-":
                                          showMoney = money! + "-" + money1;
                                          break;
                                        case "x":
                                          showMoney = money! + "x" + money1;
                                          break;
                                        case "/":
                                          showMoney = money! + "/" + money1;
                                          break;
                                        default:
                                      }
                                    }
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      right: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                      bottom: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '1',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (showMoney!.length > 14) {
                                    isNegative = true;
                                    setState(() {});
                                    Timer(Duration(seconds: 3), () {
                                      isNegative = false;
                                      setState(() {});
                                    });
                                  } else {
                                    if (showMoney == "0") {
                                      showMoney = "2";
                                    } else if (Sign == "") {
                                      showMoney = showMoney! + "2";
                                      money = showMoney!.replaceAll(",", "");
                                      updateMoney(money!);
                                    } else if (Sign != "") {
                                      showMoney = showMoney! + "2";
                                      money = showMoney!.substring(
                                          0, showMoney!.indexOf(Sign));
                                      money1 = showMoney!.substring(
                                          showMoney!.indexOf(Sign) + 1);
                                      print(money! + " + " + money1);
                                      money1 = money1.replaceAll(",", "");
                                      money1 = FormatMoney(money1);
                                      print(money! + " + " + money1);
                                      switch (Sign) {
                                        case "+":
                                          showMoney = money! + "+" + money1;
                                          break;
                                        case "-":
                                          showMoney = money! + "-" + money1;
                                          break;
                                        case "x":
                                          showMoney = money! + "x" + money1;
                                          break;
                                        case "/":
                                          showMoney = money! + "/" + money1;
                                          break;
                                        default:
                                      }
                                    }
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      right: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                      bottom: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '2',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (showMoney!.length > 14) {
                                    isNegative = true;
                                    setState(() {});
                                    Timer(Duration(seconds: 3), () {
                                      isNegative = false;
                                      setState(() {});
                                    });
                                  } else {
                                    if (showMoney == "0") {
                                      showMoney = "3";
                                    } else if (Sign == "") {
                                      showMoney = showMoney! + "3";
                                      money = showMoney!.replaceAll(",", "");
                                      updateMoney(money!);
                                    } else if (Sign != "") {
                                      showMoney = showMoney! + "3";
                                      money = showMoney!.substring(
                                          0, showMoney!.indexOf(Sign));
                                      money1 = showMoney!.substring(
                                          showMoney!.indexOf(Sign) + 1);
                                      print(money! + " + " + money1);
                                      money1 = money1.replaceAll(",", "");
                                      money1 = FormatMoney(money1);
                                      print(money! + " " + money1);
                                      switch (Sign) {
                                        case "+":
                                          showMoney = money! + "+" + money1;
                                          break;
                                        case "-":
                                          showMoney = money! + "-" + money1;
                                          break;
                                        case "x":
                                          showMoney = money! + "x" + money1;
                                          break;
                                        case "/":
                                          showMoney = money! + "/" + money1;
                                          break;
                                        default:
                                      }
                                    }
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      right: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                      bottom: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '3',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (showMoney![showMoney!.length - 1] ==
                                      Sign) {
                                    Sign = "";
                                  }
                                  showMoney = showMoney!
                                      .substring(0, showMoney!.length - 1);
                                  showMoney = showMoney!.replaceAll(',', "");
                                  updateMoney(showMoney!);
                                  if (showMoney == "") {
                                    showMoney = "0";
                                  }
                                  setState(() {});
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 230, 233, 237),
                                    border: Border(
                                      right: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                      bottom: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                    ),
                                  ),
                                  child: const Center(
                                      child: Icon(Icons.backspace)),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (showMoney!.length > 14) {
                                    isNegative = true;
                                    setState(() {});
                                    Timer(Duration(seconds: 3), () {
                                      isNegative = false;
                                      setState(() {});
                                    });
                                  } else {
                                    if (showMoney == "0") {
                                      showMoney = "4";
                                    } else if (Sign == "") {
                                      showMoney = showMoney! + "4";
                                      money = showMoney!.replaceAll(",", "");
                                      updateMoney(money!);
                                    } else if (Sign != "") {
                                      showMoney = showMoney! + "4";
                                      money = showMoney!.substring(
                                          0, showMoney!.indexOf(Sign));
                                      money1 = showMoney!.substring(
                                          showMoney!.indexOf(Sign) + 1);
                                      print(money! + " + " + money1);
                                      money1 = money1.replaceAll(",", "");
                                      money1 = FormatMoney(money1);
                                      print(money! + " " + money1);
                                      switch (Sign) {
                                        case "+":
                                          showMoney = money! + "+" + money1;
                                          break;
                                        case "-":
                                          showMoney = money! + "-" + money1;
                                          break;
                                        case "x":
                                          showMoney = money! + "x" + money1;
                                          break;
                                        case "/":
                                          showMoney = money! + "/" + money1;
                                          break;
                                        default:
                                      }
                                    }
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      right: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                      bottom: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '4',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (showMoney!.length > 14) {
                                    isNegative = true;
                                    setState(() {});
                                    Timer(Duration(seconds: 3), () {
                                      isNegative = false;
                                      setState(() {});
                                    });
                                  } else {
                                    if (showMoney == "0") {
                                      showMoney = "5";
                                    } else if (Sign == "") {
                                      showMoney = showMoney! + "5";
                                      money = showMoney!.replaceAll(",", "");
                                      updateMoney(money!);
                                    } else if (Sign != "") {
                                      showMoney = showMoney! + "5";
                                      money = showMoney!.substring(
                                          0, showMoney!.indexOf(Sign));
                                      money1 = showMoney!.substring(
                                          showMoney!.indexOf(Sign) + 1);
                                      print(money! + " + " + money1);
                                      money1 = money1.replaceAll(",", "");
                                      money1 = FormatMoney(money1);
                                      print(money! + " " + money1);
                                      switch (Sign) {
                                        case "+":
                                          showMoney = money! + "+" + money1;
                                          break;
                                        case "-":
                                          showMoney = money! + "-" + money1;
                                          break;
                                        case "x":
                                          showMoney = money! + "x" + money1;
                                          break;
                                        case "/":
                                          showMoney = money! + "/" + money1;
                                          break;
                                        default:
                                      }
                                    }
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      right: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                      bottom: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '5',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (showMoney!.length > 14) {
                                    isNegative = true;
                                    setState(() {});
                                    Timer(Duration(seconds: 3), () {
                                      isNegative = false;
                                      setState(() {});
                                    });
                                  } else {
                                    if (showMoney == "0") {
                                      showMoney = "6";
                                    } else if (Sign == "") {
                                      showMoney = showMoney! + "6";
                                      money = showMoney!.replaceAll(",", "");
                                      updateMoney(money!);
                                    } else if (Sign != "") {
                                      showMoney = showMoney! + "6";
                                      money = showMoney!.substring(
                                          0, showMoney!.indexOf(Sign));
                                      money1 = showMoney!.substring(
                                          showMoney!.indexOf(Sign) + 1);
                                      print(money! + " + " + money1);
                                      money1 = money1.replaceAll(",", "");
                                      money1 = FormatMoney(money1);
                                      print(money! + " " + money1);
                                      switch (Sign) {
                                        case "+":
                                          showMoney = money! + "+" + money1;
                                          break;
                                        case "-":
                                          showMoney = money! + "-" + money1;
                                          break;
                                        case "x":
                                          showMoney = money! + "x" + money1;
                                          break;
                                        case "/":
                                          showMoney = money! + "/" + money1;
                                          break;
                                        default:
                                      }
                                    }
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      right: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                      bottom: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '6',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showMoney = "0";
                                  money1 = "";
                                  Sign = "";
                                  setState(() {});
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 230, 233, 237),
                                    border: Border(
                                      right: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                      bottom: BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'AC',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (showMoney!.length > 14) {
                                            isNegative = true;
                                            setState(() {});
                                            Timer(Duration(seconds: 3), () {
                                              isNegative = false;
                                              setState(() {});
                                            });
                                          } else {
                                            if (showMoney == "0") {
                                              showMoney = "7";
                                            } else if (Sign == "") {
                                              showMoney = showMoney! + "7";
                                              money = showMoney!
                                                  .replaceAll(",", "");
                                              updateMoney(money!);
                                            } else if (Sign != "") {
                                              showMoney = showMoney! + "7";
                                              money = showMoney!.substring(
                                                  0, showMoney!.indexOf(Sign));
                                              money1 = showMoney!.substring(
                                                  showMoney!.indexOf(Sign) + 1);
                                              print(money! + " + " + money1);
                                              money1 =
                                                  money1.replaceAll(",", "");
                                              money1 = FormatMoney(money1);
                                              print(money! + " " + money1);
                                              switch (Sign) {
                                                case "+":
                                                  showMoney =
                                                      money! + "+" + money1;
                                                  break;
                                                case "-":
                                                  showMoney =
                                                      money! + "-" + money1;
                                                  break;
                                                case "x":
                                                  showMoney =
                                                      money! + "x" + money1;
                                                  break;
                                                case "/":
                                                  showMoney =
                                                      money! + "/" + money1;
                                                  break;
                                                default:
                                              }
                                            }
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              15,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                              right: BorderSide(
                                                width: 1,
                                                color: Color.fromARGB(
                                                    255, 201, 201, 201),
                                              ),
                                              bottom: BorderSide(
                                                width: 1,
                                                color: Color.fromARGB(
                                                    255, 201, 201, 201),
                                              ),
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              '7',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (showMoney!.length > 14) {
                                            isNegative = true;
                                            setState(() {});
                                            Timer(Duration(seconds: 3), () {
                                              isNegative = false;
                                              setState(() {});
                                            });
                                          } else {
                                            if (showMoney == "0") {
                                              showMoney = "8";
                                            } else if (Sign == "") {
                                              showMoney = showMoney! + "8";
                                              money = showMoney!
                                                  .replaceAll(",", "");
                                              updateMoney(money!);
                                            } else if (Sign != "") {
                                              showMoney = showMoney! + "8";
                                              money = showMoney!.substring(
                                                  0, showMoney!.indexOf(Sign));
                                              money1 = showMoney!.substring(
                                                  showMoney!.indexOf(Sign) + 1);
                                              money1 =
                                                  money1.replaceAll(",", "");
                                              money1 = FormatMoney(money1);
                                              print(money! + " " + money1);
                                              switch (Sign) {
                                                case "+":
                                                  showMoney =
                                                      money! + "+" + money1;
                                                  break;
                                                case "-":
                                                  showMoney =
                                                      money! + "-" + money1;
                                                  break;
                                                case "x":
                                                  showMoney =
                                                      money! + "x" + money1;
                                                  break;
                                                case "/":
                                                  showMoney =
                                                      money! + "/" + money1;
                                                  break;
                                                default:
                                              }
                                            }
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              15,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                              right: BorderSide(
                                                width: 1,
                                                color: Color.fromARGB(
                                                    255, 201, 201, 201),
                                              ),
                                              bottom: BorderSide(
                                                width: 1,
                                                color: Color.fromARGB(
                                                    255, 201, 201, 201),
                                              ),
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              '8',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (showMoney!.length > 14) {
                                            isNegative = true;
                                            setState(() {});
                                            Timer(Duration(seconds: 3), () {
                                              isNegative = false;
                                              setState(() {});
                                            });
                                          } else {
                                            if (showMoney == "0") {
                                              showMoney = "9";
                                            } else if (Sign == "") {
                                              showMoney = showMoney! + "9";
                                              money = showMoney!
                                                  .replaceAll(",", "");
                                              updateMoney(money!);
                                            } else if (Sign != "") {
                                              showMoney = showMoney! + "9";
                                              money = showMoney!.substring(
                                                  0, showMoney!.indexOf(Sign));
                                              money1 = showMoney!.substring(
                                                  showMoney!.indexOf(Sign) + 1);
                                              print(money! + " + " + money1);
                                              money1 =
                                                  money1.replaceAll(",", "");
                                              money1 = FormatMoney(money1);
                                              print(money! + " " + money1);
                                              switch (Sign) {
                                                case "+":
                                                  showMoney =
                                                      money! + "+" + money1;
                                                  break;
                                                case "-":
                                                  showMoney =
                                                      money! + "-" + money1;
                                                  break;
                                                case "x":
                                                  showMoney =
                                                      money! + "x" + money1;
                                                  break;
                                                case "/":
                                                  showMoney =
                                                      money! + "/" + money1;
                                                  break;
                                                default:
                                              }
                                            }
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              15,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                              right: BorderSide(
                                                width: 1,
                                                color: Color.fromARGB(
                                                    255, 201, 201, 201),
                                              ),
                                              bottom: BorderSide(
                                                width: 1,
                                                color: Color.fromARGB(
                                                    255, 201, 201, 201),
                                              ),
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              '9',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (showMoney!.length > 14) {
                                            isNegative = true;
                                            setState(() {});
                                            Timer(Duration(seconds: 3), () {
                                              isNegative = false;
                                              setState(() {});
                                            });
                                          } else {
                                            if (showMoney == "0") {
                                              showMoney = "0";
                                            } else if (Sign == "") {
                                              showMoney = showMoney! + "0";
                                              money = showMoney!
                                                  .replaceAll(",", "");
                                              updateMoney(money!);
                                            } else if (Sign != "") {
                                              showMoney = showMoney! + "0";
                                              money = showMoney!.substring(
                                                  0, showMoney!.indexOf(Sign));
                                              money1 = showMoney!.substring(
                                                  showMoney!.indexOf(Sign) + 1);
                                              print(money! + " + " + money1);
                                              money1 =
                                                  money1.replaceAll(",", "");
                                              money1 = FormatMoney(money1);
                                              print(money! + " " + money1);
                                              switch (Sign) {
                                                case "+":
                                                  showMoney =
                                                      money! + "+" + money1;
                                                  break;
                                                case "-":
                                                  showMoney =
                                                      money! + "-" + money1;
                                                  break;
                                                case "x":
                                                  showMoney =
                                                      money! + "x" + money1;
                                                  break;
                                                case "/":
                                                  showMoney =
                                                      money! + "/" + money1;
                                                  break;
                                                default:
                                              }
                                            }
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              15,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                              right: BorderSide(
                                                width: 1,
                                                color: Color.fromARGB(
                                                    255, 201, 201, 201),
                                              ),
                                              bottom: BorderSide(
                                                width: 1,
                                                color: Color.fromARGB(
                                                    255, 201, 201, 201),
                                              ),
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              '0',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (showMoney!.length > 14) {
                                            isNegative = true;
                                            setState(() {});
                                            Timer(Duration(seconds: 3), () {
                                              isNegative = false;
                                              setState(() {});
                                            });
                                          } else {
                                            if (showMoney == "0") {
                                              showMoney = "0";
                                            } else if (Sign == "") {
                                              showMoney = showMoney! + "000";
                                              money = showMoney!
                                                  .replaceAll(",", "");
                                              updateMoney(money!);
                                            } else if (Sign != "") {
                                              showMoney = showMoney! + "000";
                                              money = showMoney!.substring(
                                                  0, showMoney!.indexOf(Sign));
                                              money1 = showMoney!.substring(
                                                  showMoney!.indexOf(Sign) + 1);
                                              print(money! + " + " + money1);
                                              money1 =
                                                  money1.replaceAll(",", "");
                                              money1 = FormatMoney(money1);
                                              print(money! + " " + money1);
                                              switch (Sign) {
                                                case "+":
                                                  showMoney =
                                                      money! + "+" + money1;
                                                  break;
                                                case "-":
                                                  showMoney =
                                                      money! + "-" + money1;
                                                  break;
                                                case "x":
                                                  showMoney =
                                                      money! + "x" + money1;
                                                  break;
                                                case "/":
                                                  showMoney =
                                                      money! + "/" + money1;
                                                  break;
                                                default:
                                              }
                                            }
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              15,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                              right: BorderSide(
                                                width: 1,
                                                color: Color.fromARGB(
                                                    255, 201, 201, 201),
                                              ),
                                              bottom: BorderSide(
                                                width: 1,
                                                color: Color.fromARGB(
                                                    255, 201, 201, 201),
                                              ),
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              '000',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              15,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                              right: BorderSide(
                                                width: 1,
                                                color: Color.fromARGB(
                                                    255, 201, 201, 201),
                                              ),
                                              bottom: BorderSide(
                                                width: 1,
                                                color: Color.fromARGB(
                                                    255, 201, 201, 201),
                                              ),
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              '',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  if (Sign != "" && money1 != "") {
                                    money = money!.replaceAll(',', '');
                                    int a = int.parse(money!);
                                    money1 = money1.replaceAll(',', '');
                                    int b = int.parse(money1);
                                    dynamic c;
                                    if (b != 0) {
                                      switch (Sign) {
                                        case "+":
                                          c = a + b;
                                          break;
                                        case "-":
                                          c = a - b;
                                          break;
                                        case "x":
                                          c = a * b;
                                          break;
                                        case "/":
                                          c = a / b;
                                          break;
                                        default:
                                      }
                                      if (c is double) {
                                        c = c.toInt();
                                      }
                                    } else {
                                      c = 0;
                                    }

                                    updateMoney(c.toString());
                                    money1 = "";
                                    Sign = "";
                                    setState(() {});
                                  } else {
                                    if (Sign != "") {
                                      showMoney = showMoney!
                                          .substring(0, showMoney!.length - 1);
                                      Sign = "";
                                    }

                                    showCalculator = false;
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  height: (MediaQuery.of(context).size.height /
                                          15) *
                                      2,
                                  color: Colors.green,
                                  child: Center(
                                    child: Text(
                                      ((Sign != "" && money1 != "")
                                          ? '='
                                          : "Xong"),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
