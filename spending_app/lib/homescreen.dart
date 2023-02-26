import 'package:app_chi_tieu/account_page.dart';
import 'package:app_chi_tieu/add_category.dart';
import 'package:app_chi_tieu/main.dart';
import 'package:app_chi_tieu/recordpage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';
import 'models/user.dart';
import 'notifications_page.dart';

Color mainColor = Colors.green;

class HomeScreen extends StatefulWidget {
  final String uid;
  HomeScreen({super.key, required this.uid});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _alertAddScreens(BuildContext context, User user) async {
    dynamic result = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => AddCategory(
            uid: this.widget.uid,
            user: user,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ));
    if (result == 1) {
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        showCloseIcon: true,
        title: 'Thành Công',
        desc: 'Đã thêm mới 1 bản ghi',
        descTextStyle: TextStyle(fontWeight: FontWeight.w500),
        btnOkOnPress: () {},
        btnOkIcon: Icons.check_circle,
      ).show();
    }
    setState(() {});
  }

  Future<User> fetchUsers() async {
    final _snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(this.widget.uid)
        .get();
    final data = _snapshot.data();
    final user = User.fromJson(data!);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
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
          } else if (snapshot.hasData) {
            User user = snapshot.data!;
            const TextStyle optionStyle =
                TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Center(
                child: _selectedIndex == 0
                    ? HomePage(
                        uid: this.widget.uid,
                      )
                    : _selectedIndex == 1
                        ? RecordPage(
                            uid: this.widget.uid,
                            user: user,
                          )
                        : _selectedIndex == 2
                            ? NotificationPage()
                            : _selectedIndex == 3
                                ? AccountPage(
                                    user: user,
                                  )
                                : Container(),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                iconSize: 20,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                    ),
                    label: 'Tổng Quan',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.library_books,
                    ),
                    label: 'Ghi chép',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.notifications),
                    label: 'Thông báo',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Tài Khoản',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.green,
                onTap: _onItemTapped,
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: mainColor,
                onPressed: () {
                  _alertAddScreens(context, user);
                },
                child: const Icon(Icons.add),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
            );
          } else
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        });
  }
}
