import 'dart:async';
import 'dart:io';
import 'package:app_chi_tieu/homescreen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;

import 'package:app_chi_tieu/components/color.dart';
import 'package:app_chi_tieu/components/typemoney.dart';
import 'package:app_chi_tieu/detailimage.dart';
import 'package:app_chi_tieu/functions/caculator.dart';
import 'package:app_chi_tieu/models/category.dart';
import 'package:app_chi_tieu/select_category.dart';

import 'functions/geticon.dart';
import 'models/user.dart';

class AddCategory extends StatefulWidget {
  String uid;
  User user;
  AddCategory({super.key, required this.uid, required this.user});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  double _opacity = 0.0;
  TextEditingController noteController = TextEditingController();
  double addHeight = 302.0;
  String Sign = "";
  bool showCalculator = false;
  var formatter = NumberFormat('#,###,000');
  String? showMoney;
  double _value = 0;
  String? money;
  String money1 = "";
  bool temp = false;
  DateTime selectedDate = DateTime.now();
  File? imageFile;
  final _picker = ImagePicker();
  @override
  void initState() {
    money = "0";
    updateMoney(money!);
    setState(() {});
    super.initState();
  }

  Future createCategory({
    required String id,
    required String uid,
    required int money,
    required String category,
    required String type,
    required String note,
    required DateTime time,
    required bool image,
  }) async {
    final _category = Category(
        id: id,
        uid: uid,
        money: money,
        category: category,
        type: type,
        note: note,
        time: time,
        image: image);
    await FirebaseFirestore.instance
        .collection('category')
        .doc("$id")
        .set(_category.toJson());
  }

  Future uploadFile(File _image, String id) async {
    print(Path.basename(_image.path));
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference = storage.ref().child('images/$id.png');
    await storageReference.putFile(_image);
  }

  bool isNegative = false;
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

  String _selectedItem = "";
  String _typeMoney = "";

  _navigateAndDisplaySelection(BuildContext context) async {
    dynamic result = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              SelectCategory(
            selectedSubject: _selectedItem,
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
      TypeMoney typeMoney = result as TypeMoney;
      _selectedItem = (result.subject is Null)
          ? (_selectedItem == "" ? "" : _selectedItem)
          : result.subject;
      _typeMoney = (result.type is Null)
          ? (_typeMoney == "" ? "" : _typeMoney)
          : result.type;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String formatDay = DateFormat('dd/MM/yyyy').format(selectedDate);
    String formatHour = DateFormat('HH:mm').format(selectedDate);
    bool isToday = DateFormat('dd/MM/yyyy').format(selectedDate) ==
        DateFormat('dd/MM/yyyy').format(DateTime.now());
    bool isYesterday = DateFormat('dd/MM/yyyy').format(selectedDate) ==
        DateFormat('dd/MM/yyyy')
            .format(DateTime.now().subtract(Duration(days: 1)));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
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
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color.fromARGB(255, 234, 231, 231),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 15),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    color: Colors.green,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Text(
                          _typeMoney == "" ? 'Thêm Hạng Mục' : _typeMoney,
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        Container(
                          child: IconButton(
                            icon: const Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 100,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Số tiền',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                color: _typeMoney == ""
                                                    ? Colors.black
                                                    : (_typeMoney == "Chi Tiêu"
                                                        ? Colors.red
                                                        : Colors.green)),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Text('đ',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0))),
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    width:
                                        MediaQuery.of(context).size.width - 80,
                                    color: Colors.black,
                                  ),
                                  isNegative
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 10, 10, 10),
                                              child: Text(
                                                showMoney!.length > 14
                                                    ? "Số tiền quá lớn vui lòng thử lại"
                                                    : 'Số tiền không được âm.',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            )
                                          ],
                                        )
                                      : Container(),
                                ],
                              )),
                          Container(
                            padding: EdgeInsets.only(left: 10, top: 10),
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            child: Column(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    print(_selectedItem);
                                    _navigateAndDisplaySelection(context);
                                    print(_selectedItem);
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            _selectedItem == ""
                                                ? Icon(
                                                    Icons
                                                        .error_outline_outlined,
                                                    color: Colors.red,
                                                    size: 35,
                                                  )
                                                : Container(
                                                    alignment: Alignment.center,
                                                    padding: EdgeInsets.all(5),
                                                    width: 45,
                                                    height: 45,
                                                    decoration: BoxDecoration(
                                                        color: boldColors[15],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    child: Image.asset(
                                                      geticon(_selectedItem),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                _selectedItem == ""
                                                    ? 'Chọn danh mục'
                                                    : _selectedItem,
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            _navigateAndDisplaySelection(
                                                context);
                                          },
                                          icon: Icon(
                                            Icons.navigate_next,
                                            size: 25,
                                            color: Colors.grey,
                                          ))
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(bottom: 20, top: 10),
                                      width: MediaQuery.of(context).size.width -
                                          55,
                                      height: 0.5,
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.note_add,
                                      size: 30,
                                      color: Colors.grey,
                                    ),
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      padding: EdgeInsets.only(left: 15),
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      height: 40,
                                      child: TextField(
                                          controller: noteController,
                                          onTap: () {
                                            showCalculator = false;
                                            setState(() {});
                                          },
                                          maxLines: null,
                                          minLines: null,
                                          expands: true,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                          decoration: InputDecoration.collapsed(
                                              hintText: "thêm chú thích",
                                              hintStyle: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey))),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(bottom: 20, top: 15),
                                      width: MediaQuery.of(context).size.width -
                                          55,
                                      height: 0.5,
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_month_rounded,
                                            size: 30,
                                            color: Colors.grey,
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                showDatePicker(
                                                  context: context,
                                                  locale: Locale('vi', 'VN'),
                                                  initialDate: selectedDate,
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime(2100),
                                                ).then((date) {
                                                  if (date != null) {
                                                    setState(() {
                                                      final newTime = DateTime(
                                                          date.year,
                                                          date.month,
                                                          date.day,
                                                          selectedDate.hour,
                                                          selectedDate.minute);
                                                      setState(() {
                                                        selectedDate = newTime;
                                                      });
                                                    });
                                                  }
                                                });
                                              },
                                              child: Text(
                                                (isToday
                                                        ? "Hôm Nay - "
                                                        : (isYesterday
                                                            ? "Hôm Qua - "
                                                            : "")) +
                                                    '$formatDay',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          showTimePicker(
                                            initialEntryMode:
                                                TimePickerEntryMode.input,
                                            context: context,
                                            initialTime: TimeOfDay.fromDateTime(
                                                selectedDate),
                                          ).then((time) {
                                            if (time != null) {
                                              final newTime = DateTime(
                                                  selectedDate.year,
                                                  selectedDate.month,
                                                  selectedDate.day,
                                                  time.hour,
                                                  time.minute);
                                              setState(() {
                                                selectedDate = newTime;
                                              });
                                            }
                                          });
                                        },
                                        child: Text(
                                          formatHour,
                                          style: TextStyle(color: Colors.black),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(
                                left: 10, top: 20, right: 10, bottom: 20),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text('Ảnh (không bắt buộc)'),
                                ),
                                imageFile != null
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () async =>
                                                _pickImageFromGallery(),
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  20,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 0.5),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5),
                                                  bottomLeft:
                                                      Radius.circular(5),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.image,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async =>
                                                _pickImageFromCamera(),
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2 -
                                                  20,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 0.5),
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(5),
                                                  bottomRight:
                                                      Radius.circular(5),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.camera_alt,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                imageFile == null
                                    ? Container()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (context,
                                                                animation,
                                                                secondaryAnimation) =>
                                                            DetailImage(
                                                                imageFile:
                                                                    imageFile!),
                                                        transitionsBuilder:
                                                            (context,
                                                                animation,
                                                                secondaryAnimation,
                                                                child) {
                                                          return SlideTransition(
                                                            position:
                                                                Tween<Offset>(
                                                              begin:
                                                                  const Offset(
                                                                      1.0, 0.0),
                                                              end: Offset.zero,
                                                            ).animate(
                                                                    animation),
                                                            child: child,
                                                          );
                                                        },
                                                      ));
                                                },
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(top: 20),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      80,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      80,
                                                  child: Image.file(
                                                    imageFile!,
                                                    fit: BoxFit.contain,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            80,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            80,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                  top: 20,
                                                  right: 0,
                                                  child: IconButton(
                                                      onPressed: () {
                                                        imageFile = null;
                                                        setState(() {});
                                                      },
                                                      icon: Icon(Icons.close))),
                                            ],
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 20),
                                width: MediaQuery.of(context).size.width / 1.7,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    final snackBar = SnackBar(
                                        duration: Duration(seconds: 2),
                                        elevation: 0,
                                        behavior: SnackBarBehavior.fixed,
                                        backgroundColor: Colors.transparent,
                                        content: Container(
                                            padding:
                                                EdgeInsets.fromLTRB(5, 0, 5, 0),
                                            width: 300,
                                            height: 70,
                                            decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 255, 198, 64),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Icon(
                                                  Icons.error_outline_rounded,
                                                  size: 35,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    "Bạn chưa chọn danh mục để thêm ghi chép.",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    softWrap: true,
                                                    maxLines: 2,
                                                  ),
                                                )
                                              ],
                                            )));
                                    if (_selectedItem == "") {
                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(snackBar);
                                    } else {
                                      final docCategory = FirebaseFirestore
                                          .instance
                                          .collection('category')
                                          .doc();
                                      String _id = docCategory.id;
                                      if (imageFile == null) {
                                        final doc = FirebaseFirestore.instance
                                            .collection('users')
                                            .doc("${this.widget.uid}");
                                        int updateMoney = 0;
                                        if (_typeMoney == "Thu Nhập") {
                                          updateMoney =
                                              this.widget.user.accountBalance +
                                                  int.parse(showMoney!
                                                      .replaceAll(",", ""));
                                        } else if (_typeMoney == "Chi Tiêu") {
                                          updateMoney =
                                              this.widget.user.accountBalance -
                                                  int.parse(showMoney!
                                                      .replaceAll(",", ""));
                                        }

                                        doc.update(
                                            {'accountBalance': updateMoney});
                                        createCategory(
                                            id: _id,
                                            uid: this.widget.uid,
                                            money: int.parse(
                                                showMoney!.replaceAll(",", "")),
                                            category: _selectedItem,
                                            type: _typeMoney,
                                            note: noteController.text,
                                            time: selectedDate,
                                            image: false);
                                        Navigator.pop(context, 1);
                                      } else {
                                        final doc = FirebaseFirestore.instance
                                            .collection('users')
                                            .doc("${this.widget.uid}");
                                        int updateMoney = 0;
                                        if (_typeMoney == "Thu Nhập") {
                                          updateMoney =
                                              this.widget.user.accountBalance +
                                                  int.parse(showMoney!
                                                      .replaceAll(",", ""));
                                        } else if (_typeMoney == "Chi Tiêu") {
                                          updateMoney =
                                              this.widget.user.accountBalance -
                                                  int.parse(showMoney!
                                                      .replaceAll(",", ""));
                                        }

                                        doc.update(
                                            {'accountBalance': updateMoney});
                                        uploadFile(imageFile!, _id);
                                        createCategory(
                                            id: _id,
                                            uid: this.widget.uid,
                                            money: int.parse(
                                                showMoney!.replaceAll(",", "")),
                                            category: _selectedItem,
                                            type: _typeMoney,
                                            note: noteController.text,
                                            time: selectedDate,
                                            image: true);
                                        Navigator.pop(context, 1);
                                      }
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.save,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        'Thêm Mới',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          showCalculator == true
                              ? Container(
                                  height: addHeight,
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => imageFile = File(pickedFile.path));
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => imageFile = File(pickedFile.path));
    }
  }
}
