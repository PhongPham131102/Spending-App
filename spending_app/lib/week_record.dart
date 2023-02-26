import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'components/detail_category_follow_time.dart';
import 'models/category.dart';
import 'models/user.dart';

class WeekRecord extends StatefulWidget {
  String uid;
  User user;
  WeekRecord({super.key, required this.uid,required this.user});

  @override
  State<WeekRecord> createState() => _WeekRecordState();
}

class _WeekRecordState extends State<WeekRecord> {
  String dropdownvalue = 'Tuần này';
  var items = [
    "Tuần này",
    "Tuần trước",
  ];
  List<Widget> getWidgetOfWeek = [];
  GetDataWeek(
      List<Category> getWeek, List<Category> all, BuildContext context) {
    getWidgetOfWeek = [];
    List<Category> uniqueCategoryTime = [];
    for (Category child in getWeek) {
      if (uniqueCategoryTime
          .where((c) =>
              DateFormat('dd/MM/yyyy').format(c.time) ==
              DateFormat('dd/MM/yyyy').format(child.time))
          .isEmpty) {
        uniqueCategoryTime.add(child);
      }
    }
    uniqueCategoryTime.sort(((a, b) => b.time.compareTo(a.time)));
    for (var element in uniqueCategoryTime) {
      getWidgetOfWeek
          .add(GetDayCategory(context, all, element.time, this.widget.uid,this.widget.user));
    }
  }

  int temp = 0;
  Stream<List<Category>> fetchCategories() => FirebaseFirestore.instance
      .collection('category')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList());
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
            List<Category> thisWeek = [];
            List<Category> lastWeek = [];
            DateTime now = DateTime.now();
            DateTime firstDayOfWeek =
                now.subtract(Duration(days: now.weekday - 1));

            DateTime lastDayOfWeek = firstDayOfWeek.add(Duration(days: 6));

            DateTime firstDayOfLastWeek =
                now.subtract(Duration(days: firstDayOfWeek.day - 7));

            DateTime lastDayOfLastWeek =
                firstDayOfLastWeek.add(Duration(days: 6));
            for (var i in categories) {
              if (i.time.isAfter(firstDayOfWeek) &&
                  i.time.isBefore(lastDayOfWeek) &&
                  i.uid == this.widget.uid) {
                thisWeek.add(i);
              }
              if (i.time.isAfter(firstDayOfLastWeek) &&
                  i.time.isBefore(lastDayOfLastWeek) &&
                  i.uid == this.widget.uid) {
                lastWeek.add(i);
              }
            }
            if (temp == 0) GetDataWeek(thisWeek, categories, context);
            return Scaffold(
              body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Color.fromARGB(60, 216, 215, 215),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      alignment: Alignment.center,
                      child: DropdownButton(
                        value: dropdownvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          temp = 1;
                          setState(() {
                            dropdownvalue = newValue!;
                            if (newValue == "Tuần này") {
                              GetDataWeek(thisWeek, categories, context);
                            } else if (newValue == "Tuần trước") {
                              GetDataWeek(lastWeek, categories, context);
                            }
                          });
                        },
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 188,
                        child: SingleChildScrollView(
                            child: Column(
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
                          ],
                        )))
                  ],
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
