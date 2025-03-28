import 'package:flutter/material.dart';

const ash = Color(0xFF232327);
const lightAsh = Color(0xFF6F7384);
const black = Colors.black;
const ligthYellowLight = Color(0xFFFFF1B1);
const white = Colors.white;
const teal = Color(0xFF68C292);

final darkTheme = ThemeData(
  fontFamily: 'OdinRounded',
  scaffoldBackgroundColor: const Color(0xFF121212),
  colorScheme: const ColorScheme.dark().copyWith(
    primary: black,
    secondary: ash,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: teal,
      foregroundColor: white,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      minimumSize: const Size.fromHeight(55),
      backgroundColor: teal,
      foregroundColor: white,
      // minimumSize: const Size(double.infinity, 65),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),

      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
     border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)), // Rounded corners
      ),
    focusedBorder:  OutlineInputBorder(
      borderSide:const BorderSide(color: teal, width: 0.9),
      borderRadius: BorderRadius.circular(14)
    ),
    enabledBorder:  OutlineInputBorder(
      borderSide: const BorderSide(color: lightAsh, width: 0.9),
         
      borderRadius: BorderRadius.circular(14)
    
    
    ),
    hintStyle:const  TextStyle(color: lightAsh),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: teal, // Sets the cursor color for all text fields
  ),
);

final lightTheme = ThemeData(
  fontFamily: 'OdinRounded',
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  indicatorColor: black,
  colorScheme: const ColorScheme.light().copyWith(
    primary: white,
    secondary: black,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: teal,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: black,
      foregroundColor: white,
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: black,
      foregroundColor: white,
      minimumSize: const Size.fromHeight(55),
      // minimumSize: const Size(double.infinity, 65),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18.0),
    ),
    focusedBorder:  OutlineInputBorder(
      borderSide:const BorderSide(color: teal, width: 0.9),
      borderRadius: BorderRadius.circular(14)

    ),
    enabledBorder:  OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.grey, width: 0.9),
      borderRadius: BorderRadius.circular(14)
    ),
    hintStyle: const TextStyle(color: Colors.grey),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: teal, // Sets the cursor color for all text fields
  ),

);
