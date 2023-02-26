import 'dart:convert';

double GetPercent(int first,int last)
{
  return (((first-last)/last)*100).roundToDouble();
}