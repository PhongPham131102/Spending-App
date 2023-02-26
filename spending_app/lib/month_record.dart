import 'package:app_chi_tieu/components/detail_category_follow_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';

import 'models/category.dart';
import 'models/user.dart';

class MonthRecord extends StatefulWidget {
  String uid;
  User user;
  MonthRecord({super.key, required this.uid,required this.user});

  @override
  State<MonthRecord> createState() => _MonthRecordState();
}

class _MonthRecordState extends State<MonthRecord> {
  String dropdownvalue = 'Tháng này';
  var items = [
    'Tháng này',
    'Tháng trước',
    'Tháng khác',
  ];
  DateTime selectedDate = DateTime.now();
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
    for (var element in uniqueCategoryTime) {
      if (element.time.month == selectedDate.month) getMonth.add(element.time);
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
            if (temp == 0) {
              GetDataWeek(categoriesOfUser);
            }
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
                            dropdownvalue = newValue!;
                            if (newValue == "Tháng này") {
                              selectedDate = DateTime.now();
                            } else if (newValue == "Tháng trước") {
                              DateTime now = DateTime.now();
                              DateTime time = DateTime(now.year, now.month - 1);
                              selectedDate = time;
                            } else if (newValue == "Tháng khác") {
                              temp = 1;
                              showMonthPicker(
                                headerColor:Colors.green,
                                selectedMonthBackgroundColor:Color.fromARGB(255, 71, 179, 71),
                                unselectedMonthTextColor:Color.fromARGB(255, 223, 182, 69),
                                confirmText:Text("Chọn",style: TextStyle(
                                ),),
                                 cancelText:Text("Hủy",style: TextStyle(
                                ),),
                                context: context,
                                locale: Locale('vi', 'VN'),
                                initialDate: selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2050),
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
                                      GetDataWeek(categoriesOfUser);
                                    });
                                  });
                                }
                              });
                            }
                            GetDataWeek(categoriesOfUser);
                            setState(() {});
                          }),
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
