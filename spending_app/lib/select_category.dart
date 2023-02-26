import 'dart:ui';
import 'package:app_chi_tieu/components/Icon.dart';
import 'package:app_chi_tieu/components/color.dart';
import 'package:app_chi_tieu/components/selecticon.dart';
import 'package:app_chi_tieu/components/texticon.dart';
import 'package:app_chi_tieu/components/typemoney.dart';
import 'package:app_chi_tieu/functions/geticon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:async';

import 'package:flutter_randomcolor/flutter_randomcolor.dart';

class SelectCategory extends StatefulWidget {
  String selectedSubject;
  SelectCategory({super.key, required this.selectedSubject});

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  var color = Options(format: Format.hex, colorType: ColorType.green);
  List<isOpen> isRotate = List.generate(9, (index) => isOpen());
  List<Color> colorIcon = List.from(boldColors)..shuffle();
  List<String> subject = [
    "Ăn uống",
    "Sinh hoạt",
    "Đi lại",
    "Con cái",
    "Phụ kiện",
    "Sức khỏe",
    "Nhà cửa",
    "Hưởng thụ",
    "Phát triển bản thân",
  ];
  List<String> income = [
    "Tiền lương",
    "Tiền thưởng",
    "Khác",
  ];
  List<String> food = [
    "Đi chợ/siêu thị",
    "Cafe",
    "Ăn tiệm",
    "Ăn sáng",
    "Ăn trưa",
    "Ăn tối",
  ];
  List<String> living = [
    "Tiền điện",
    "Tiền nước",
    "Tiền mạng",
    "Tiền card Điện thoại",
    "Tiền ga",
  ];
  List<String> moving = [
    "Tiền xăng",
    "Bảo hiểm xe",
    "Sửa xe",
    "Gửi xe",
    "Rửa xe",
    "Grab",
  ];
  List<String> yourChildren = [
    "Học phí",
    "Sách vở",
    "Sữa",
    "Đồ chơi",
    "Tiền tiêu vặt",
  ];
  List<String> health = [
    "Thuốc men",
    "Khám chữa bệnh",
    "Thể thao",
  ];
  List<String> clothes = [
    "Quần áo",
    "Giày dép",
    "Làm đẹp/Mỹ phẩm",
    "Phụ kiện khác",
  ];
  List<String> home = [
    "Mua sắm",
    "Sửa nhà",
    "Thuê nhà",
  ];
  List<String> enjoy = [
    "Hoạt động giải trí",
    "Du lịch",
    "Xem phim",
  ];
  List<String> developSkill = [
    "Học hành",
    "Giao lưu",
  ];

  void rotateIcon(isOpen i) {
    i.get = !i.get;
    setState(() {});
  }

  Widget category(
      String subject, String selectedSubject, int index, String type) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            TypeMoney typeMoney = TypeMoney(subject: subject, type: type);
            Navigator.pop(context, typeMoney);
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
            width: MediaQuery.of(context).size.width,
            height: 70,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                type=="Chi Tiêu"?InkWell(
                                    onTap: () {
                                      rotateIcon(isRotate[index]);

                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
                                      child: isRotate[index].get
                                          ? Icon(Icons.expand_more)
                                          : Icon(Icons.expand_less),
                                    )):Container(width: 35,height: 35,),
                                GetIcon(subject, colorIcon[index])
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          TextIcon(subject),
                        ],
                      ),
                    ),
                    this.widget.selectedSubject == subject
                        ? CheckIcon()
                        : Container()
                  ],
                ),
                Container(
                  height: 0.2,
                  width: MediaQuery.of(context).size.width - 100,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: AnimatedOpacity(
              opacity: isRotate[index].get ? 1.0 : 0.0,
              duration: Duration(milliseconds: 2500),
              curve: Curves.easeOut,
              child: isRotate[index].get
                  ? Column(
                      children: [
                        if (subject == "Ăn uống")
                          for (var i = 0; i < food.length; i++)
                            detailCategory(
                                food[i], selectedSubject, i, "Chi Tiêu")
                        else if (subject == "Sinh hoạt")
                          for (var i = 0; i < living.length; i++)
                            detailCategory(
                                living[i], selectedSubject, i, "Chi Tiêu")
                        else if (subject == "Đi lại")
                          for (var i = 0; i < moving.length; i++)
                            detailCategory(
                                moving[i], selectedSubject, i, "Chi Tiêu")
                        else if (subject == "Con cái")
                          for (var i = 0; i < yourChildren.length; i++)
                            detailCategory(
                                yourChildren[i], selectedSubject, i, "Chi Tiêu")
                        else if (subject == "Phụ kiện")
                          for (var i = 0; i < clothes.length; i++)
                            detailCategory(
                                clothes[i], selectedSubject, i, "Chi Tiêu")
                        else if (subject == "Sức khỏe")
                          for (var i = 0; i < health.length; i++)
                            detailCategory(
                                health[i], selectedSubject, i, "Chi Tiêu")
                        else if (subject == "Nhà cửa")
                          for (var i = 0; i < home.length; i++)
                            detailCategory(
                                home[i], selectedSubject, i, "Chi Tiêu")
                        else if (subject == "Hưởng thụ")
                          for (var i = 0; i < enjoy.length; i++)
                            detailCategory(
                                enjoy[i], selectedSubject, i, "Chi Tiêu")
                        else if (subject == "Phát triển bản thân")
                          for (var i = 0; i < developSkill.length; i++)
                            detailCategory(
                                developSkill[i], selectedSubject, i, "Chi Tiêu")
                      ],
                    )
                  : Container()),
        ),
      ],
    );
  }

  Widget detailCategory(
      String subject, String selectedSubject, int index, String type) {
    return InkWell(
      onTap: () {
        TypeMoney typeMoney = TypeMoney(subject: subject, type: type);
        Navigator.pop(context, typeMoney);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: 70,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 35),
                        child: Row(
                          children: [GetIcon(subject, colorIcon[index])],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      TextIcon(subject),
                    ],
                  ),
                ),
                this.widget.selectedSubject == subject
                    ? CheckIcon()
                    : Container()
              ],
            ),
            Container(
              height: 0.2,
              width: MediaQuery.of(context).size.width - 110,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text(
              'Thêm Hạng Mục',
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Chi Tiêu',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              Tab(
                child: Text(
                  'Thu Nhập',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color.fromARGB(255, 234, 231, 231),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var i = 0; i < 9; i++)
                      category(subject[i], this.widget.selectedSubject, i,
                          "Chi Tiêu")
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color.fromARGB(255, 255, 255, 255),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (var i = 0; i < 3; i++)
                      category(income[i], this.widget.selectedSubject, i,
                          "Thu Nhập")
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class isOpen {
  bool get = false;
}
