import 'package:cse_pub_client/models/menus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cse_pub_client/themes.dart';
import 'package:cse_pub_client/models/menus.dart';
import 'dart:convert';
class Order {
  final int id;
  final int income;
  final int tableID;
  final String time;
  final String name;
  final List<int> menuQuantities;
  final List<bool> menuChecked;
  bool isPaid;

  Order({
    required this.id,
    required this.income,
    required this.tableID,
    required this.time,
    required this.name,
    required this.menuQuantities,
    required this.menuChecked,
    required this.isPaid,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final menus = json['menus'] as Map<String, dynamic>;

    final quantities = <int>[];
    final checked = <bool>[];

    for (var key in menuKeys) {
      quantities.add(menus[key]['count'] as int);
      checked.add(menus[key]['checked'] as bool);
    }

    return Order(
      id: json['id'] as int,
      income: json['income'] as int,
      tableID: json['tableID'] as int,
      time: json['time'] as String,
      name: json['name'] as String,
      menuQuantities: quantities,
      menuChecked: checked,
      isPaid: json['paid'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    final menuMap = <String, dynamic>{};
    for (int i = 0; i < menuCount; i++) {
      menuMap[menuKeys[i]] = {
        'checked': menuChecked[i],
        'count': menuQuantities[i],
      };
    }

    return {
      'id': id,
      'income': income,
      'tableID': tableID,
      'time': time,
      'name': name,
      'menus': menuMap,
      'paid': isPaid,
    };
  }

  bool get isCompleted {
    for (int i = 0; i < menuQuantities.length; i++) {
      if (menuQuantities[i]!=0&&menuChecked[i]==false) return false;
    }
    return isPaid;
  }
}