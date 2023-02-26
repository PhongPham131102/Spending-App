import 'package:flutter/material.dart';

Container CheckIcon() {
  return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Icon(
        Icons.done,
        color: Colors.white,
        size: 15,
      ));
}
