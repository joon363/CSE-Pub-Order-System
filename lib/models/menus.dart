import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cse_pub_client/themes.dart';
import 'package:cse_pub_client/pages/order_table_page.dart';
import 'dart:convert';

class MenuItem {
  final String name;
  final int index;
  final int price;
  final String imageUrl;

  MenuItem({required this.name, required this.index, required this.price, required this.imageUrl});
}
List<MenuItem> menuItems = [
  MenuItem(name: '삼겹살(100g)', index: 0, price: 6500, imageUrl: 'assets/samg.jpg'),
  MenuItem(name: '껍데기(100g)', index: 1, price: 5500, imageUrl: 'assets/ggup.jpg'),
  MenuItem(name: '비빔면', index: 2, price: 3000, imageUrl: 'assets/bibim.jpg'),
  MenuItem(name: '불닭게티(2인분)', index: 3, price: 5500, imageUrl: 'assets/buldark.jpg'),
  MenuItem(name: '소주 세트', index: 4, price: 5000, imageUrl: 'assets/setA.jpg'),
  MenuItem(name: '음료 세트', index: 5, price: 3500, imageUrl: 'assets/setB.jpg'),
];
const int menuCount = 6;
const menuKeys = ['menu0', 'menu1', 'menu2', 'menu3', 'menu4', 'menu5'];
const menuDisplayNames = ['삼겹살', '껍데기', '비빔면', '불닭게티', '소주 세트', '음료 세트'];