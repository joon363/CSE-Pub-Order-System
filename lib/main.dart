import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cse_pub_client/themes.dart';
import 'package:cse_pub_client/pages/client_page.dart';
import 'package:cse_pub_client/pages/order_table_page.dart';
import 'dart:convert';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OrderPage(),
      theme: AppTheme.darkTheme(context),
      debugShowCheckedModeBanner: false,
    );
  }
}
