import "package:flutter/material.dart";

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("bạn chưa có thông báo nào!",style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color:Colors.grey,
        ),),
      ),
    );
  }
}
