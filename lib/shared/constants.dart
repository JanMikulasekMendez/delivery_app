import 'package:deliveryapp/models/package.dart';
import 'package:deliveryapp/screens/home/my_cell.dart';
import 'package:flutter/material.dart';

class MyThemes {
  static final backgroundColor = Colors.brown[100];
  static final backgroundColorAlt = Colors.orange[100];
  static final navbarColor = Colors.brown[400];
  static final gradientColorA = Colors.brown[900];
  static final gradientColorB = Colors.brown[100];
  static final buttonColor = Colors.brown[700];
  static final barButtonColor = Colors.orange[100];

  static const textFieldBorderColor = Colors.black;
  static const textFieldBackgroundColor = Colors.white38;
  static const textColor = Colors.white;
  static final titleColor = Colors.orange[100];
  static const errorColor = Colors.red;
}

class MyTextSize {
  static const double micro = 10.0;
  static const double tiny = 14.0;
  static const double small = 18.0;
  static const double medium = 22.0;
  static const double large = 26.0;
}

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide:
        BorderSide(color: MyThemes.textFieldBackgroundColor, width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: MyThemes.textFieldBorderColor, width: 2.0),
  ),
);

InputDecoration textInputDecoration2 = InputDecoration(
  floatingLabelBehavior: FloatingLabelBehavior.auto,
  //hintText: "Enter Something Funny",
  hintStyle: TextStyle(color: MyThemes.navbarColor),
  //labelText: "TextField",
  labelStyle: TextStyle(
    color: MyThemes.buttonColor,
  ),
  //helperText: 'Keep it short, this is just a demo.',
  helperStyle: TextStyle(color: MyThemes.buttonColor),
  counterStyle: TextStyle(color: MyThemes.buttonColor),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: MyThemes.textFieldBorderColor),
    borderRadius: BorderRadius.circular(10),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: MyThemes.buttonColor!),
    borderRadius: BorderRadius.circular(50),
  ),
  filled: true,
  fillColor: MyThemes.textFieldBackgroundColor,
  border: OutlineInputBorder(
    borderSide: BorderSide(color: MyThemes.buttonColor!),
  ),
);

BoxDecoration gradientDecoration = BoxDecoration(
    gradient: LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    MyThemes.gradientColorA!,
    MyThemes.gradientColorB!,
  ],
));

TextStyle textStyle = TextStyle(color: MyThemes.textColor, fontSize: 18);

TextStyle titleStyle = TextStyle(color: MyThemes.titleColor, fontSize: 25);


