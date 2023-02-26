import 'package:app_chi_tieu/first_login.dart';
import 'package:app_chi_tieu/homescreen.dart';
import 'package:app_chi_tieu/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signin_signup.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main(List<String> args) async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor:
        Color.fromARGB(0, 255, 255, 255), // Đặt màu nền cho thanh trạng thái
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String id = "";
  String is_logined = "";
  int accountBalance = 0;
  get_is_logined() async {
    final SharedPreferences cookie = await SharedPreferences.getInstance();
    is_logined = cookie.getString('is_logined') != null
        ? cookie.getString('is_logined')!
        : '';
    setState(() {});
  }

  get_account_balance() async {
    final SharedPreferences cookie = await SharedPreferences.getInstance();
    accountBalance =
        cookie.getInt('ac_balance') != null ? cookie.getInt('ac_balance')! : 0;
    setState(() {});
  }

  get_id() async {
    final SharedPreferences cookie = await SharedPreferences.getInstance();
    id = cookie.getString('id') != null ? cookie.getString('id')! : '';
    setState(() {});
  }

  @override
  void initState() {
    get_id();
    get_is_logined();
    get_account_balance();
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.green, // Đặt màu nền cho thanh trạng thái
    ));
    if (accountBalance == -1 && is_logined == "1" && id != "") {
      return MaterialApp(
        routes: {
          "/Signin": (context) => SignIn(),
        },
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
        ],
        supportedLocales: [Locale('vi', 'VN')],
        debugShowCheckedModeBanner: false,
        home: First_Login(
          uid: id,
        ),
      );
    } else if (is_logined == "1" && id != "") {
      return MaterialApp(
        routes: {
          "/Signin": (context) => SignIn(),
        },
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
        ],
        supportedLocales: [Locale('vi', 'VN')],
        debugShowCheckedModeBanner: false,
        home: HomeScreen(
          uid: id,
        ),
      );
    } else {
      return MaterialApp(
        routes: {
          "/Signin": (context) => SignIn(),
        },
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
        ],
        supportedLocales: [Locale('vi', 'VN')],
        debugShowCheckedModeBanner: false,
        home: SignIn_Up(),
      );
    }
  }
}
