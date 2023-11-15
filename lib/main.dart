// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:login/login.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyLogin(),
    routes: {
      'login': (context) => MyApp(),
    },
  ));
}