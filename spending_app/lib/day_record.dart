import 'package:app_chi_tieu/components/detail_category_follow_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';

import 'models/category.dart';
import 'models/user.dart';

class DayRecord extends StatefulWidget {
  String uid;
  User user;
  DayRecord({super.key, required this.uid,required this.user});

  @override
  State<DayRecord> createState() => _DayRecordState();
}

class _DayRecordState extends State<DayRecord> {
  String dropdownvalue = 'Hôm nay';
  var items = [
    'Hôm nay',
    'Hôm qua',
    'Ngày khác',
  ];
  DateTime selectedDate = DateTime.now();
  Stream<List<Category>> fetchCategories() => FirebaseFirestore.instance
      .collection('category')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Category.fromJson(doc.data())).toList());
  @override
  Widget build(BuildContext context) {
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
                  setState(() {
                    dropdownvalue = newValue!;
                    if (newValue == "Hôm nay") {
                      selectedDate = DateTime.now();
                    }else if(newValue == "Hôm qua")
                    {
                      selectedDate = DateTime.now().subtract(Duration(days: 1));
                    }
                    if (newValue == "Ngày khác") {
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
                    }
                  });
                },
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 188,
                child: StreamBuilder(
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
                        List<Category> categories = snapshot.data!.toList();
                        return SingleChildScrollView(
                            child: Column(
                          children: [
                            GetDayCategory(context, categories, selectedDate,
                                this.widget.uid,this.widget.user),
                          ],
                        ));
                      } else
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    }))
          ],
        ),
      ),
    );
  }
}
