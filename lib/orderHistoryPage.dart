import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cse_pub_client/themes.dart';
import 'dart:convert';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 더미 주문 데이터
    final List<Map<String, dynamic>> orders = [
      {'orderId': 1, 'date': '2025-04-27', 'items': '메뉴1 x2, 메뉴2 x1', 'total': 5000},
      {'orderId': 2, 'date': '2025-04-26', 'items': '메뉴3 x1', 'total': 3000},
      {'orderId': 3, 'date': '2025-04-25', 'items': '메뉴2 x2', 'total': 8000},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('주문 내역')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final order = orders[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(order['orderId'].toString()),
            ),
            title: Text('날짜: ${order['date']}'),
            subtitle: Text('주문 목록: ${order['items']}'),
            trailing: Text('${order['total']}원'),
          );
        },
      ),
    );
  }
}