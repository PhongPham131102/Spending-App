import 'package:app_chi_tieu/components/detail_category.dart';
import 'package:app_chi_tieu/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'components/chart.dart';
import 'components/color.dart';
import 'functions/caculator_percent_spending.dart';
import 'functions/convert_to_vnd.dart';
import 'models/user.dart';

class HomePage extends StatefulWidget {
  String uid;
  HomePage({super.key, required this.uid});

  @override
  State<HomePage> createState() => _HomePageState();
}

Color mainColor = Colors.green;

class _HomePageState extends State<HomePage> {
  bool _isObscure = true;
  String dropdownvalue = 'Hôm nay';
  var items = [
    'Hôm nay',
    'Tuần này',
    'Tháng này',
    'Năm nay',
  ];
  int _index = 0;
  bool _scroll = true;
  double _height = 534;
  final ScrollController _controller = ScrollController();
  var formatter = NumberFormat('#,###,000');
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

  List<Category> allCategories = [];
  int income = 0;
  int spending = 0;
  getCategory(List<Category> categories) {
    allCategories = [];
    income = 0;
    spending = 0;
    for (var element in categories) {
      if (element.type == "Chi Tiêu") {
        spending += element.money;
        allCategories.add(element);
      } else {
        income += element.money;
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

//khởi tạo temp bằng 0 để khi lần đầu truy cập vào màn hình thì lấy bảng ghi của hôm nay
  List<Category> spendingWeekCategory = [];
  List<Category> spendingMonthCategory = [];

  int totalSpendingThisWeek = 0;
  int totalSpendingLastWeek = 0;
  double percentSpendingThisWeek = 0;
  int totalSpendingThisMonth = 0;
  int totalSpendingLastMonth = 0;
  double percentSpendingThisMonth = 0;
  GetSpendingWeek(List<Category> thisWeek, List<Category> lastWeek) {
    spendingWeekCategory = [];
    totalSpendingThisWeek = 0;
    totalSpendingLastWeek = 0;
    percentSpendingThisWeek = 0;
    for (var element in thisWeek) {
      if (element.type == "Chi Tiêu") {
        totalSpendingThisWeek += element.money;
        spendingWeekCategory.add(element);
      }
    }
    for (var element in lastWeek) {
      if (element.type == "Chi Tiêu") {
        totalSpendingLastWeek += element.money;
      }
    }
  }

  GetSpendingMonth(List<Category> thisMonth, List<Category> lastMonth) {
    spendingMonthCategory = [];
    totalSpendingThisMonth = 0;
    totalSpendingLastMonth = 0;
    percentSpendingThisWeek = 0;
    for (var element in thisMonth) {
      if (element.type == "Chi Tiêu") {
        totalSpendingThisMonth += element.money;
        spendingMonthCategory.add(element);
      }
    }
    for (var element in lastMonth) {
      if (element.type == "Chi Tiêu") {
        totalSpendingLastMonth += element.money;
      }
    }
  }

  int temp = 0;
  @override
  Widget build(BuildContext context) {
    Future<User> fetchUsers() async {
      final _snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(this.widget.uid)
          .get();
      final data = _snapshot.data();
      final user = User.fromJson(data!);
      return user;
    }

    Stream<List<Category>> fetchCategories() => FirebaseFirestore.instance
        .collection('category')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList());
    return Scaffold(
        body: FutureBuilder(
            future: fetchUsers(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
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
              } else if (snapshot.hasData) {
                return Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: const Color.fromARGB(255, 226, 224, 224),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 40, 20, 5),
                          width: MediaQuery.of(context).size.width,
                          height: 166,
                          color: mainColor,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Chào ${snapshot.data!.fullName}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Icon(
                                      Icons.notifications,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 30, 10),
                                margin: const EdgeInsets.only(top: 15),
                                width: MediaQuery.of(context).size.width - 40,
                                height:
                                    (MediaQuery.of(context).size.height / 6) /
                                            2.5 +
                                        25,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: const [
                                            Text(
                                              "Tổng số dư",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          _isObscure
                                              ? "${FormatMoney(snapshot.data!.accountBalance.toString())} đ"
                                              : "****** đ",
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                              color: mainColor),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _isObscure = !_isObscure;
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        _isObscure
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        size: 30,
                                        color: Colors.grey,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        StreamBuilder(
                            stream: fetchCategories(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError)
                                return AlertDialog(
                                  title: const Text('Thông Báo'),
                                  content: Text(
                                      'Lỗi server.\n Mã lỗi :${snapshot.error}'),
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
                                List<Category> categoriess =
                                    snapshot.data!.toList();
                                List<Category> LastWeek = [];
                                List<Category> LastMonth = [];
                                List<Category> thisWeek = [];
                                List<Category> thisMonth = [];
                                List<Category> thisYear = [];
                                List<Category> today = [];
                                DateTime now = DateTime.now();
                                //lấy ngày đầu tiên của tuần tức thứ 2 và ở đây trừ 1 vì now.weekday bắt đầu từ 1(thứ hai )đến chủ nhật(7) ví dụ hôm nay thứ 4 nếu muốn tìm ngày đầu tuần tức thứ 4 - 2 ngày(tương đương now.weekday=3 -1)
                                DateTime firstDayOfWeek = now
                                    .subtract(Duration(days: now.weekday - 1));
                                //lấy ngày cuối tuần trong tuần tức chủ nhật ở đây đơn giản là lấy ngày đầu tuần là thứ 2  cộng thêm cho 6 ngày
                                DateTime lastDayOfWeek =
                                    firstDayOfWeek.add(Duration(days: 6));

                                DateTime firstDayOfLastWeek = now.subtract(
                                    Duration(days: firstDayOfWeek.day - 7));

                                DateTime lastDayOfLastWeek =
                                    firstDayOfLastWeek.add(Duration(days: 6));

                                for (var i in categoriess) {
                                  if (DateFormat('dd/MM/yyyy').format(i.time) ==
                                          DateFormat('dd/MM/yyyy')
                                              .format(DateTime.now()) &&
                                      i.uid == this.widget.uid) {
                                    today.add(i);
                                  }
                                  if (i.time.isAfter(firstDayOfWeek) &&
                                      i.time.isBefore(lastDayOfWeek) &&
                                      i.uid == this.widget.uid) {
                                    thisWeek.add(i);
                                  }
                                  if (i.time.month == now.month &&
                                      i.uid == this.widget.uid) {
                                    thisMonth.add(i);
                                  }
                                  if (i.time.year == now.year &&
                                      i.uid == this.widget.uid) {
                                    thisYear.add(i);
                                  }
                                  if (i.time.isAfter(firstDayOfLastWeek) &&
                                      i.time.isBefore(lastDayOfLastWeek) &&
                                      i.uid == this.widget.uid) {
                                    LastWeek.add(i);
                                  }
                                  if (i.time.month == now.month - 1 &&
                                      i.uid == this.widget.uid) {
                                    LastMonth.add(i);
                                  }
                                }
                                if (temp == 0) {
                                  getCategory(today);
                                  GetSpendingWeek(thisWeek, LastWeek);
                                  GetSpendingMonth(thisMonth, LastMonth);
                                }
                                return Container(
                                  height: _height,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.all(10),
                                          color: Colors.white,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Tình hình thu chi',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              DropdownButton(
                                                value: dropdownvalue,
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                items:
                                                    items.map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  temp = 1;
                                                  allCategories = [];
                                                  income = 0;
                                                  spending = 0;
                                                  if (newValue == "Hôm nay") {
                                                    getCategory(today);
                                                  } else if (newValue ==
                                                      "Tuần này") {
                                                    getCategory(thisWeek);
                                                  } else if (newValue ==
                                                      "Tháng này") {
                                                    getCategory(thisMonth);
                                                  } else if (newValue ==
                                                      "Năm nay") {
                                                    getCategory(thisYear);
                                                  }
                                                  dropdownvalue = newValue!;
                                                  setState(() {});
                                                },
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    height: 120,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              (!calPercent(spending + income, income)
                                                                          .isNaN &&
                                                                      !calPercent(
                                                                              spending + income,
                                                                              income)
                                                                          .isInfinite)
                                                                  ? "${calPercent(spending + income, income).toInt()}%"
                                                                  : '0%',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      53,
                                                                      203,
                                                                      7),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          10),
                                                              width: 35,
                                                              height: (!calPercent(
                                                                              spending +
                                                                                  income,
                                                                              income)
                                                                          .isNaN &&
                                                                      !calPercent(
                                                                              spending +
                                                                                  income,
                                                                              income)
                                                                          .isInfinite)
                                                                  ? calPercent(
                                                                      spending +
                                                                          income,
                                                                      income)
                                                                  : 1,
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              (!calPercent(spending + income, income)
                                                                          .isNaN &&
                                                                      !calPercent(
                                                                              spending + income,
                                                                              income)
                                                                          .isInfinite)
                                                                  ? "${calPercent(spending + income, spending).toInt()}%"
                                                                  : "0%",
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              color: Colors.red,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          10),
                                                              width: 35,
                                                              height: (!calPercent(
                                                                              spending +
                                                                                  income,
                                                                              income)
                                                                          .isNaN &&
                                                                      !calPercent(
                                                                              spending +
                                                                                  income,
                                                                              income)
                                                                          .isInfinite)
                                                                  ? calPercent(
                                                                      spending +
                                                                          income,
                                                                      spending)
                                                                  : 1,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2 +
                                                            50,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            8,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              5),
                                                                  width: 10,
                                                                  height: 10,
                                                                  decoration: BoxDecoration(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          53,
                                                                          203,
                                                                          7),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                ),
                                                                Text(
                                                                  "Thu",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                )
                                                              ],
                                                            ),
                                                            Text(
                                                              _isObscure
                                                                  ? (income == 0
                                                                      ? "0 đ"
                                                                      : "${formatter.format(income)} đ")
                                                                  : "****** đ",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          53,
                                                                          203,
                                                                          7),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          right:
                                                                              5),
                                                                      width: 10,
                                                                      height:
                                                                          10,
                                                                      decoration: BoxDecoration(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              53,
                                                                              203,
                                                                              7),
                                                                          borderRadius:
                                                                              BorderRadius.circular(10)),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  "Chi",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                )
                                                              ],
                                                            ),
                                                            Text(
                                                              _isObscure
                                                                  ? (spending ==
                                                                          0
                                                                      ? "0 đ"
                                                                      : "${formatter.format(spending)} đ")
                                                                  : "****** đ",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            )
                                                          ],
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 15,
                                                                  left: 15),
                                                          height: 1,
                                                          width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  2 +
                                                              50,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          1),
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(20),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 1,
                                                color: Colors.grey,
                                              ),
                                              allCategories.length == 0
                                                  ? Container(
                                                      height: 100,
                                                      child: Center(
                                                        child: Text(
                                                          "Bạn chưa có bản ghi nào !",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                    )
                                                  : GetChart(boldColors,
                                                      allCategories, context),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 50),
                                          color: Colors.white,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Báo cáo chi tiêu',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 10, bottom: 10),
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 3, 0, 3),
                                                decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 240, 237, 237),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        _index = 0;
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 3),
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            14.5,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: _index == 0
                                                                ? Colors.white
                                                                : Color
                                                                    .fromARGB(
                                                                        255,
                                                                        240,
                                                                        237,
                                                                        237),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          'Tuần',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        _index = 1;
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 3),
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            14.5,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                            color: _index == 1
                                                                ? Colors.white
                                                                : Color
                                                                    .fromARGB(
                                                                        255,
                                                                        240,
                                                                        237,
                                                                        237),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          'Tháng',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              //chi tiêu tuần
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    50,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      (_index == 0)
                                                          ? totalSpendingThisWeek >
                                                                  0
                                                              ? "${formatter.format(totalSpendingThisWeek)} đ"
                                                              : "0 đ"
                                                          : totalSpendingThisMonth >
                                                                  0
                                                              ? "${formatter.format(totalSpendingThisMonth)} đ"
                                                              : "0 đ",
                                                      style: TextStyle(
                                                          fontSize: 23,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Tổng chi tiêu ${_index == 0 ? "tuần" : "tháng"} này',
                                                          style: const TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      151,
                                                                      145,
                                                                      145),
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10,
                                                                  right: 5),
                                                          width: 24,
                                                          height: 24,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          24),
                                                              color: Color
                                                                  .fromARGB(
                                                                      85,
                                                                      172,
                                                                      170,
                                                                      170)),
                                                          child: (_index == 0)
                                                              ? (totalSpendingThisWeek ==
                                                                      totalSpendingLastWeek)
                                                                  ? Icon(
                                                                      Icons
                                                                          .remove,
                                                                      size: 20,
                                                                      color: Colors
                                                                          .black,
                                                                    )
                                                                  : (totalSpendingLastWeek >
                                                                          totalSpendingThisWeek)
                                                                      ? Icon(
                                                                          Icons
                                                                              .south_sharp,
                                                                          size:
                                                                              20,
                                                                          color: Colors
                                                                              .green)
                                                                      : Icon(
                                                                          Icons
                                                                              .north,
                                                                          size:
                                                                              20,
                                                                          color:
                                                                              Colors.red,
                                                                        )
                                                              : (totalSpendingThisMonth ==
                                                                      totalSpendingLastMonth)
                                                                  ? Icon(
                                                                      Icons
                                                                          .remove,
                                                                      size: 20,
                                                                      color: Colors
                                                                          .black,
                                                                    )
                                                                  : (totalSpendingLastMonth >
                                                                          totalSpendingThisMonth)
                                                                      ? Icon(
                                                                          Icons
                                                                              .south_sharp,
                                                                          size:
                                                                              20,
                                                                          color:
                                                                              Colors.green)
                                                                      : Icon(
                                                                          Icons
                                                                              .north,
                                                                          size:
                                                                              20,
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                        ),
                                                        Text(
                                                          (_index == 0)
                                                              ? (!GetPercent(totalSpendingThisWeek,
                                                                              totalSpendingLastWeek)
                                                                          .isNaN &&
                                                                      !GetPercent(
                                                                              totalSpendingThisWeek,
                                                                              totalSpendingLastWeek)
                                                                          .isInfinite)
                                                                  ? (GetPercent(
                                                                              totalSpendingThisWeek,
                                                                              totalSpendingLastWeek) >
                                                                          0)
                                                                      ? "${GetPercent(totalSpendingThisWeek, totalSpendingLastWeek).toInt()} %"
                                                                      : "${GetPercent(totalSpendingThisWeek, totalSpendingLastWeek).abs().toInt()} %"
                                                                  : "0%"
                                                              : (!GetPercent(totalSpendingThisMonth,
                                                                              totalSpendingLastMonth)
                                                                          .isNaN &&
                                                                      !GetPercent(
                                                                              totalSpendingThisMonth,
                                                                              totalSpendingLastMonth)
                                                                          .isInfinite)
                                                                  ? (GetPercent(
                                                                              totalSpendingThisMonth,
                                                                              totalSpendingLastMonth) >
                                                                          0)
                                                                      ? "${GetPercent(totalSpendingThisMonth, totalSpendingLastMonth).toInt()} %"
                                                                      : "${GetPercent(totalSpendingThisMonth, totalSpendingLastMonth).abs().toInt()} %"
                                                                  : "0%",
                                                          style: TextStyle(
                                                              color: (_index ==
                                                                      0)
                                                                  ? (totalSpendingThisWeek ==
                                                                          totalSpendingLastWeek)
                                                                      ? Colors
                                                                          .black
                                                                      : (totalSpendingLastWeek >
                                                                              totalSpendingThisWeek)
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .red
                                                                  : (totalSpendingThisMonth ==
                                                                          totalSpendingLastMonth)
                                                                      ? Colors
                                                                          .black
                                                                      : (totalSpendingLastMonth >
                                                                              totalSpendingThisMonth)
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .red,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                    Container(
                                                      height: 180,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            height: 180,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.8,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    Container(
                                                                      width: 50,
                                                                      height: (_index ==
                                                                              0)
                                                                          ? (totalSpendingLastWeek == totalSpendingThisWeek && totalSpendingLastWeek != 0 && totalSpendingThisWeek != 0)
                                                                              ? 150
                                                                              : (totalSpendingLastWeek == totalSpendingThisWeek && totalSpendingLastWeek == 0)
                                                                                  ? 0
                                                                                  : (totalSpendingLastWeek < totalSpendingThisWeek)
                                                                                      ? calPercent((totalSpendingThisWeek), totalSpendingLastWeek) * 1.5
                                                                                      : 150
                                                                          : (totalSpendingLastMonth == totalSpendingThisMonth && totalSpendingLastMonth != 0 && totalSpendingThisMonth != 0)
                                                                              ? 150
                                                                              : (totalSpendingLastMonth == totalSpendingThisMonth && totalSpendingLastMonth == 0)
                                                                                  ? 0
                                                                                  : (totalSpendingLastMonth < totalSpendingThisMonth)
                                                                                      ? calPercent((totalSpendingThisMonth), totalSpendingLastMonth) * 1.5
                                                                                      : 150,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .red,
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(5),
                                                                              topRight: Radius.circular(5))),
                                                                    ),
                                                                    Container(
                                                                      width: 50,
                                                                      height: (_index ==
                                                                              0)
                                                                          ? (totalSpendingLastWeek == totalSpendingThisWeek && totalSpendingLastWeek != 0 && totalSpendingThisWeek != 0)
                                                                              ? 150
                                                                              : (totalSpendingLastWeek == totalSpendingThisWeek && totalSpendingLastWeek == 0)
                                                                                  ? 0
                                                                                  : (totalSpendingLastWeek > totalSpendingThisWeek)
                                                                                      ? calPercent((totalSpendingLastWeek), totalSpendingThisWeek) * 1.5
                                                                                      : 150
                                                                          : (totalSpendingLastMonth == totalSpendingThisMonth && totalSpendingLastMonth != 0 && totalSpendingThisMonth != 0)
                                                                              ? 150
                                                                              : (totalSpendingLastMonth == totalSpendingThisMonth && totalSpendingLastMonth == 0)
                                                                                  ? 0
                                                                                  : (totalSpendingLastMonth > totalSpendingThisMonth)
                                                                                      ? calPercent((totalSpendingLastMonth), totalSpendingThisMonth) * 1.5
                                                                                      : 150,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .red,
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(5),
                                                                              topRight: Radius.circular(5))),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Container(
                                                                  height: 1,
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      1.8,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    Text(
                                                                      '${_index == 0 ? "Tuần" : "Tháng"} trước',
                                                                      style: TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              175,
                                                                              173,
                                                                              173),
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                    Text(
                                                                      '${_index == 0 ? "Tuần" : "Tháng"} này',
                                                                      style: TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              175,
                                                                              173,
                                                                              173),
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 10),
                                                            height: 180,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                (_index == 0)
                                                                    ? (totalSpendingThisWeek !=
                                                                                0 ||
                                                                            totalSpendingLastWeek !=
                                                                                0)
                                                                        ? Text(
                                                                            (_index == 0)
                                                                                ? (totalSpendingThisWeek > totalSpendingLastWeek)
                                                                                    ? ConvertToVND(totalSpendingThisWeek)
                                                                                    : ConvertToVND(totalSpendingLastWeek)
                                                                                : (totalSpendingThisMonth > totalSpendingLastMonth)
                                                                                    ? ConvertToVND(totalSpendingThisMonth)
                                                                                    : ConvertToVND(totalSpendingLastMonth),
                                                                            softWrap:
                                                                                true,
                                                                            style:
                                                                                TextStyle(color: Color.fromARGB(255, 175, 173, 173), fontWeight: FontWeight.w600),
                                                                          )
                                                                        : Container()
                                                                    : (totalSpendingThisMonth !=
                                                                                0 ||
                                                                            totalSpendingLastMonth !=
                                                                                0)
                                                                        ? Text(
                                                                            (_index == 0)
                                                                                ? (totalSpendingThisWeek > totalSpendingLastWeek)
                                                                                    ? ConvertToVND(totalSpendingThisWeek)
                                                                                    : ConvertToVND(totalSpendingLastWeek)
                                                                                : (totalSpendingThisMonth > totalSpendingLastMonth)
                                                                                    ? ConvertToVND(totalSpendingThisMonth)
                                                                                    : ConvertToVND(totalSpendingLastMonth),
                                                                            softWrap:
                                                                                true,
                                                                            style:
                                                                                TextStyle(color: Color.fromARGB(255, 175, 173, 173), fontWeight: FontWeight.w600),
                                                                          )
                                                                        : Container(),
                                                                Text(
                                                                  '0đ',
                                                                  style: TextStyle(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          175,
                                                                          173,
                                                                          173),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    (_index == 0 &&
                                                            spendingWeekCategory
                                                                    .length !=
                                                                0)
                                                        ? BestSpendingCateGory(
                                                            spendingWeekCategory,
                                                            totalSpendingThisWeek,
                                                            context)
                                                        : (_index == 1 &&
                                                                spendingMonthCategory
                                                                        .length !=
                                                                    0)
                                                            ? BestSpendingCateGory(
                                                                spendingMonthCategory,
                                                                totalSpendingThisMonth,
                                                                context)
                                                            : Container()
                                                  ],
                                                ),
                                              ), // kết thúc chi tiêu tuần
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                            })
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
