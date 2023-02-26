import 'package:app_chi_tieu/models/category.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Icon.dart';

PieChartSectionData GetDetailChart(
    Color color, double value, String subject, String title) {
  return PieChartSectionData(
      color: color,
      value: value,
      title: "",
      radius: 45,
      badgeWidget: GetIconForChart(subject, color),
      badgePositionPercentageOffset: 0.8);
}

Widget GetChart(
    List<Color> colors, List<Category> categories1, BuildContext context) {
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
  //xáo trộn màu
  colors.shuffle();
  //tạo 1 list các section
  List<PieChartSectionData> sections = [];
  //tạo 1 list các row
  List<Widget> detailRows = [];
  //sắp xếp các danh mục theo thứ tự money từ lớn đến bé
  categories.sort(((a, b) => b.money.compareTo(a.money)));

  //tạo 1 category để gom tất cả các danh mục có số money thấp và khi số danh mục trong list categories lớn hơn 5
  Category lastCategory = Category(
      id: "",
      uid: "",
      money: 0,
      category: "Khác",
      type: "Chi tiêu",
      note: "",
      time: DateTime.now(),
      image: true);
  //xét nếu như số danh mục lớn hơn 5
  int total = 0;
  if (categories.length > 5) {
    for (int i = 0; i < categories.length - 1; i++) {
      Category temp = categories[i];
      for (int j = i + 1; j < categories.length; j++) {
        if (categories[i].category == categories[j].category) {
          categories[i].money += categories[j].money;
          categories.remove(categories[j]);
        }
      }
    }
    categories.sort(((a, b) => b.money.compareTo(a.money)));
    List<Category> _categories = [];
    for (int i = 0; i < categories.length; i++) {
      if (categories[i].type == "Chi Tiêu") {
        if (i < 4) {
          total += categories[i].money;
          _categories.add(categories[i]);
        } else {
          total += categories[i].money;
          lastCategory.money += categories[i].money;
        }
      }
    }
    if (lastCategory.money != 0) _categories.add(lastCategory);
    for (int i = 0; i < _categories.length - 1; i++) {
      Category temp = _categories[i];
      for (int j = i + 1; j < _categories.length; j++) {
        if (_categories[i].category == _categories[j].category) {
          _categories[i].money += _categories[j].money;
          _categories.removeAt(j);
        }
      }
    }
    for (int i = 0; i < _categories.length; i++) {
      sections.add(GetDetailChart(colors[i], _categories[i].money.toDouble(),
          _categories[i].category, _categories[i].category));
      detailRows.add(getDetailRowCompenent(
          _categories[i].money, total, _categories[i].category, colors[i]));
    }
  } else {
    for (int i = 0; i < categories.length - 1; i++) {
      Category temp = categories[i];
      for (int j = i + 1; j < categories.length; j++) {
        if (categories[i].category == categories[j].category) {
          categories[i].money += categories[j].money;
          categories.removeAt(j);
        }
      }
    }
    for (int i = 0; i < categories.length; i++) total += categories[i].money;
    for (int i = 0; i < categories.length; i++) {
      if (categories[i].type == "Chi Tiêu") {
        detailRows.add(getDetailRowCompenent(
            categories[i].money, total, categories[i].category, colors[i]));
        sections.add(GetDetailChart(colors[i], categories[i].money.toDouble(),
            categories[i].category, categories[i].category));
      }
    }
  }

  return Container(
    padding: EdgeInsets.only(left: 10),
    width: MediaQuery.of(context).size.width,
    height: 200,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2 - 50,
          child: PieChart(
            PieChartData(
              borderData: FlBorderData(
                show: true,
              ),
              sectionsSpace: 2,
              centerSpaceRadius: 30,
              sections: sections,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i in detailRows) i,
          ],
        )
      ],
    ),
  );
}

double calPercent(int total, int part) {
  return ((part / total) * 100).roundToDouble();
}

var formatter = NumberFormat('#,###,000');
Widget getDetailRowCompenent(int part, int total, String subject, Color color) {
  int percent = calPercent(total, part).toInt();
  return Row(
    children: [
      GetIconForDetail(subject, color),
      Text(
        "$percent% - ",
        softWrap: true,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      Text(formatter.format(part) + "đ",
          style: TextStyle(fontWeight: FontWeight.w600))
    ],
  );
}
