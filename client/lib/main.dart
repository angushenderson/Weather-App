import 'package:flutter/material.dart';
import 'package:client/screens/home_screen.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 252, 98, 228),
        backgroundColor: Color.fromARGB(255, 31, 31, 31),
        cardColor: Color.fromARGB(255, 40, 40, 40),
        accentColor: Color.fromARGB(255, 255, 255, 255),
        cursorColor: Color.fromARGB(255, 252, 98, 228),
        highlightColor: Color.fromARGB(127, 252, 98, 228),
        textSelectionColor: Color.fromARGB(127, 252, 98, 228),
        textSelectionHandleColor: Color.fromARGB(200, 252, 98, 228),
        popupMenuTheme: PopupMenuThemeData(
          textStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          // PAGE HEADING TEXT
          headline1: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 36.0,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.4,
          ),
          headline2: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0,
          ),
          headline3: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 28.0,
          ),
          // CARD TEXT
          headline4: TextStyle(
            color: Colors.white,
            fontSize: 28.0,
            fontWeight: FontWeight.w500,
          ),
          // GREYISH SUBHEADING TEXT
          headline6: TextStyle(
            color: Color.fromARGB(255, 101, 101, 101),
            fontSize: 14.0,
          ),
          // PRIMARY BUTTON TEXT
          button: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
