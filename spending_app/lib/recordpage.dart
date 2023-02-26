import 'package:app_chi_tieu/day_record.dart';
import 'package:app_chi_tieu/models/user.dart';
import 'package:app_chi_tieu/month_record.dart';
import 'package:app_chi_tieu/option_record.dart';
import 'package:app_chi_tieu/week_record.dart';
import 'package:flutter/material.dart';

class RecordPage extends StatefulWidget {
  String uid;
  User user;
  RecordPage({super.key, required this.uid,required this.user});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.green,
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text(
                    'Ngày',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                Tab(
                  child: Text(
                    'Tuần',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                Tab(
                  child: Text(
                    'Tháng',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                Tab(
                  child: Text(
                    'Tùy chọn',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            DayRecord(
              uid: this.widget.uid,
              user: this.widget.user,
            ),
            WeekRecord(uid: this.widget.uid,user: this.widget.user,),
            MonthRecord(
              uid: this.widget.uid,
              user: this.widget.user,
            ),
            OptionRecord(
              uid: this.widget.uid,
              user:this.widget.user,
            )
          ],
        ),
      ),
    );
  }
}
