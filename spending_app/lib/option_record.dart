import 'package:app_chi_tieu/day_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'components/detail_category_follow_time.dart';
import 'models/category.dart';
import 'models/user.dart';

class OptionRecord extends StatefulWidget {
  String uid;
  User user;
  OptionRecord({super.key, required this.uid,required this.user});

  @override
  State<OptionRecord> createState() => _OptionRecordState();
}

class _OptionRecordState extends State<OptionRecord> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String FormatDay(DateTime day) {
    return DateFormat('dd/MM/yyyy').format(day);
  }

  Stream<List<Category>> fetchCategories() => FirebaseFirestore.instance
      .collection('category')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList());
  List<Widget> getWidgetOfWeek = [];
  GetDataWeek(List<Category> all) {
    getWidgetOfWeek = [];
    List<DateTime> getMonth = [];
    List<Category> uniqueCategoryTime = [];
    for (Category child in all) {
      if (uniqueCategoryTime
          .where((c) =>
              DateFormat('dd/MM/yyyy').format(c.time) ==
              DateFormat('dd/MM/yyyy').format(child.time))
          .isEmpty) {
        uniqueCategoryTime.add(child);
      }
    }
    print(DateTime.now().isAfter(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day)));
    for (var element in uniqueCategoryTime) {
      if (element.time.isAfter(DateTime(startDate.year,startDate.month,startDate.day)) &&
          element.time.isBefore(DateTime(endDate.year,endDate.month,endDate.day,23,59,59)))
        getMonth.add(element.time);
    }
    for (var i in getMonth)
      getWidgetOfWeek.add(GetDayCategory(context, all, i, this.widget.uid,this.widget.user));
  }

  int temp = 0;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: fetchCategories(),
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
            List<Category> categories = snapshot.data!.toList();
            List<Category> categoriesOfUser = [];
            for (var i in categories) {
              if (i.uid == this.widget.uid) {
                categoriesOfUser.add(i);
              }
            }

            return Scaffold(
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            GetDataWeek(categoriesOfUser);
                            showDatePicker(
                              context: context,
                              locale: Locale('vi', 'VN'),
                              initialDate: startDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            ).then((date) {
                              if (date != null) {
                                setState(() {
                                  final newTime = DateTime(date.year, date.month,
                                      date.day, startDate.hour, startDate.minute);
                                  setState(() {
                                    startDate = newTime;
                                  });
                                });
                              }
                            });
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Từ ngày",
                                  style: TextStyle(color: Colors.black),
                                ),
                                Container(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        FormatDay(startDate),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 15,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              locale: Locale('vi', 'VN'),
                              initialDate: endDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            ).then((date) {
                              if (date != null) {
                                setState(() {
                                  final newTime = DateTime(date.year, date.month,
                                      date.day, endDate.hour, endDate.minute);
                                  setState(() {
                                    endDate = newTime;
                                  });
                                });
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Đến ngày",
                                  style: TextStyle(color: Colors.black),
                                ),
                                Container(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        FormatDay(endDate),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 15,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            temp = 1;
                            GetDataWeek(categoriesOfUser);
                            setState(() {});
                          },
                          child: Container(
                            width: 120,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(3)),
                            child: Center(
                                child: Text(
                              "Tìm kiếm",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            )),
                          ),
                        ),
                        temp == 1
                            ?Column(
                                    children: [
                                      if (getWidgetOfWeek.length > 0)
                                        for (var i in getWidgetOfWeek) i
                                      else
                                        Padding(
                                          padding: EdgeInsets.only(top: 50),
                                          child: Text(
                                            "không có bản ghi nào!",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )
                                    ])
                            : Container()
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }
}
