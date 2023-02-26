import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../functions/geticon.dart';

Container GetIcon(String subject, Color _color) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.all(5),
    width: 45,
    height: 45,
    decoration:
        BoxDecoration(color: _color, borderRadius: BorderRadius.circular(30)),
    child: Image.asset(
      geticon(subject),
      fit: BoxFit.fill,
    ),
  );
}

Container GetIconForChart(String subject, Color _color) {
  return Container(
    padding: EdgeInsets.all(5),
    alignment: Alignment.center,
    width: 30,
    height: 30,
    decoration:
        BoxDecoration(color: _color, borderRadius: BorderRadius.circular(30),border: Border.all(color: Colors.black)),
    child: Image.asset(
      geticon(subject),
      fit: BoxFit.fill,
    ),
  );
}


Container GetIconForDetail(String subject, Color _color) {
  return Container(
    margin: EdgeInsets.only(right: 8,bottom: 3),
    padding: EdgeInsets.all(5),
    alignment: Alignment.center,
    width: 30,
    height: 30,
    decoration:
        BoxDecoration(color: _color, borderRadius: BorderRadius.circular(30)),
    child: Image.asset(
      geticon(subject),
      fit: BoxFit.fill,
    ),
  );
}
