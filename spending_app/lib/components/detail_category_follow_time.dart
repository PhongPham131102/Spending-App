import 'package:app_chi_tieu/edit_category.dart';
import 'package:app_chi_tieu/functions/geticon.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/category.dart';
import '../models/user.dart';

Widget GetDayCategory(BuildContext context, List<Category> categories1,
    DateTime day, String uid, User user) {
  List<Category> categories = [];
  for (int i = 0; i < categories1.length; i++) {
    Category temp = Category(
        id: categories1[i].id,
        uid: categories1[i].uid,
        money: categories1[i].money,
        category: categories1[i].category,
        type: categories1[i].type,
        note: categories1[i].note,
        time: categories1[i].time,
        image: categories1[i].image);
    categories.add(temp);
  }
  List<Category> dayCategory = [];
  for (var i in categories) {
    if (DateFormat('dd/MM/yyyy').format(i.time) ==
            DateFormat('dd/MM/yyyy').format(day) &&
        i.uid == uid) {
      dayCategory.add(i);
    }
  }
  if (dayCategory.length > 0) {
    int totalincome = 0;
    int totalspending = 0;
    for (var element in dayCategory) {
      if (element.type == "Chi Tiêu") {
        totalspending += element.money;
      } else {
        totalincome += element.money;
      }
    }
    var formatter = NumberFormat('#,###,000');
    return Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(bottom: 20),
        color: Colors.white,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //khung xanh bên góc trái
              Container(
                width: 8,
                height: 60,
                color: Colors.green,
              ),
              //khoảng trắng giữa 2 container
              SizedBox(
                width: 10,
              ),
              //container chính chứa các thông tin
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 10, 5),
                width: MediaQuery.of(context).size.width - 20,
                child: Column(
                  children: [
                    //row đầu tiên chứa các thông tin ngày,tổng thu và chi
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: Colors.grey))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //mở column đầu tiên chứa thông tin ngày
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (DateFormat('dd/MM/yyyy')
                                          .format(dayCategory[0].time) ==
                                      DateFormat('dd/MM/yyyy')
                                          .format(DateTime.now()))
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "H",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "ôm nay",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    )
                                  : (DateFormat('dd/MM/yyyy')
                                              .format(dayCategory[0].time) ==
                                          DateFormat('dd/MM/yyyy').format(
                                              DateTime.now()
                                                  .subtract(Duration(days: 1))))
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "H",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "ôm qua",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          ],
                                        )
                                      : Container(),
                              Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(dayCategory[0].time),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                          // mở column thứ 2 chứa thông tin tổng tiền thu và chi
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                totalincome != 0
                                    ? "${formatter.format(totalincome)} đ"
                                    : "0 đ",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              Text(
                                totalspending != 0
                                    ? "${formatter.format(totalspending)} đ"
                                    : "0 đ",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width -
                          30, //30= 10(padding của container cha) +20(tổng chiều rộng của sizedbox và khung xanh đầu tiên)
                      decoration: DottedDecoration(
                        color: Colors.grey,
                        strokeWidth: 1,
                        linePosition: LinePosition.left,
                      ),
                      child: Column(
                        children: [
                          //Container này là mỗi thành phần chi tiêu chi tiết bao gồm tên danh mục và giá
                          for (var i in dayCategory)
                            GetdetailDayCategory(
                                context,
                                i.category,
                                "${formatter.format(i.money)} đ",
                                i.type,
                                i,
                                user),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ]));
  } else {
    return Padding(
      padding: EdgeInsets.only(top: 50),
      child: Text(
        "không có bản ghi nào!",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    );
  }
}

_alertAddScreens(BuildContext context, User user, Category category) async {
  dynamic result = await Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          EditCategory(category: category, user: user),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
  if (result == 1) {
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: 'Thành Công',
      desc: 'Đã thay đổi bản ghi vừa rồi!',
      descTextStyle: TextStyle(fontWeight: FontWeight.w500),
      btnOkOnPress: () {},
      btnOkIcon: Icons.check_circle,
    ).show();
  }
  ;
}

Widget GetdetailDayCategory(BuildContext context, String subject, String money,
    String type, Category category, User user) {
  return TextButton(
    onLongPress: () {
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.noHeader,
        showCloseIcon: true,
        title: 'Xác Nhận',
        desc: 'Bạn có chắc chắn muốn xóa bản ghi này?',
        descTextStyle: TextStyle(fontWeight: FontWeight.w500),
        btnOkOnPress: () {
          final doc = FirebaseFirestore.instance
              .collection("category")
              .doc("${category.id}");
          doc.delete();
        },
        btnCancelOnPress: () {},
        btnCancelText: "Hủy",
        btnOkText: "Xác nhận",
        btnCancelIcon: Icons.cancel,
        btnOkIcon: Icons.check_circle,
      ).show();
    },
    onPressed: () {
      _alertAddScreens(context, user, category);
    },
    child: Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "---",
                style: TextStyle(
                    color: Color.fromARGB(200, 158, 158, 158),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 5,
              ),
              Image.asset(
                geticon(subject),
                width: 35,
                height: 35,
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  category.image && category.note != ""
                      ? const Text(
                          "(đính kèm ảnh và chú thích)",
                          style: TextStyle(
                            color: Color.fromARGB(200, 158, 158, 158),
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      : category.image
                          ? const Text(
                              "(đính kèm ảnh)",
                              style: TextStyle(
                                color: Color.fromARGB(200, 158, 158, 158),
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          : category.note != ""
                              ? const Text(
                                  "(đính kèm chú thích)",
                                  style: TextStyle(
                                    color: Color.fromARGB(200, 158, 158, 158),
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                  ),
                                )
                              : const Text(""),
                ],
              ),
            ],
          ),
          Text(
            money,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: type == "Chi Tiêu" ? Colors.red : Colors.green),
          ),
        ],
      ),
    ),
  );
}
