import 'package:flutter/material.dart';
import 'dart:async';
import '../models/order.dart';
import '../services/order_service.dart';
import '../widgets/order_row_widget.dart';

class OrderTablePage extends StatefulWidget {
  const OrderTablePage({super.key});

  @override
  State<OrderTablePage> createState() => _OrderTablePageState();
}

class _OrderTablePageState extends State<OrderTablePage> {
  final OrderService _orderService = OrderService();
  List<Order> _orders = [];
  bool _isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      print("Audo feching...");
      _fetchOrders();
    });
  }

  Future<void> _fetchOrders() async {
    try {
      print("Fetching Order");
      _orders = await _orderService.fetchOrders();
      setState(() {
        _isLoading = false;
      });
      print("Order Fetched");
    } catch (e) {
      throw Exception(e);
    }
  }

  void _updateOrder(Order order) async {
    print("Updating order");
    await _orderService.updateOrder(order); // 서버에 업데이트
    await _fetchOrders();
    print("Order updated");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("주문 테이블")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _buildHeader(),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                return OrderRowWidget(
                  order: _orders[index],
                  onChanged: _updateOrder,
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildHeader({bool isDone=false}) {
    int totalMenuCounts (int i) {
      int t = 0;
      for (var order in _orders) {
        t += order.menuChecked[i]?0:order.menuQuantities[i];
      }
      return t;
    }
    int totalIncome () {
      int t = 0;
      for (var order in _orders) {
        t += order.income;
      }
      return t;
    }

    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const Expanded(flex: 2, child: Text("주문 시간", style: TextStyle(fontWeight: FontWeight.bold))),
          const Expanded(flex: 2, child: Text("주문자", style: TextStyle(fontWeight: FontWeight.bold))),
          ...List.generate(3, (i) {
            return Expanded(
              flex: 3,
              child:
              Text(isDone?"메뉴 ${i + 1}":"메뉴 ${i + 1} (잔여: ${totalMenuCounts(i)}개)",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            );
          }),
          const Expanded(flex: 2, child: Text("결제 확인", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text("총액: ${totalIncome()}", style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}