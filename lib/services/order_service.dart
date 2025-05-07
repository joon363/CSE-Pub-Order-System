import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class OrderService {
  final String baseUrl = "http://127.0.0.1:5000"; // 실제 API 주소로 교체

  Future<List<Order>> fetchOrders() async {
    final response = await http.get(Uri.parse('$baseUrl/orders'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Order.fromJson(item)).toList();
    } else {
      throw Exception("Failed to fetch orders");
    }
  }

  Future<void> updateOrder(Order order) async {
    final response = await http.put(
      Uri.parse('$baseUrl/orders/${order.id}'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(order.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update order");
    }
  }
}