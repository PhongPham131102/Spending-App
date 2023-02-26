import 'package:app_chi_tieu/components/chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../functions/geticon.dart';
import '../models/category.dart';

Column BestSpendingCateGory(
    List<Category> categories1, int total, BuildContext context) {
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
  categories.sort(((a, b) => b.money.compareTo(a.money)));
  List<Category> _categories = [];
  for (int i = 0; i < categories.length - 1; i++) {
    Category temp = categories[i];
    for (int j = i + 1; j < categories.length; j++) {
      if (categories[i].category == categories[j].category) {
        categories[i].money += categories[j].money;
        categories.removeAt(j);
      }
    }
  }
  if (categories.length > 5) {
    for (int i = 0; i < 5; i++) _categories.add(categories[i]);
  } else {
    for (int i = 0; i < categories.length; i++) _categories.add(categories[i]);
  }
  var formatter = NumberFormat('#,###,000');
  return Column(
    children: [
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            child: Text(
              "Chi tiêu nhiều nhất",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      for (int i = 0; i < _categories.length; i++)
        GetDetailCategory(
            _categories[i].category,
            _categories[i].category,
            formatter.format(_categories[i].money) + "đ",
            calPercent(total, _categories[i].money).toInt().toString() + "%",
            context)
    ],
  );
}

Widget GetDetailCategory(String img, String category, String money,
    String percent, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 60,
    padding: EdgeInsets.all(5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Image.asset(
                  geticon(img),
                  height: 35,
                  width: 35,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    money,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Text(
          percent,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.red),
        )
      ],
    ),
  );
}
