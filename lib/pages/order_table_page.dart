import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      final orders = await _orderService.fetchOrders();
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      // 오류 처리
    }
  }

  void _updateOrder(Order order) async {
    setState(() {}); // 로컬 상태 먼저 반영
    await _orderService.updateOrder(order); // 서버에 업데이트
  }

  @override
  Widget build(BuildContext context) {
    List<Order> sortedOrders = [
      ..._orders.where((o) => !o.isCompleted),
      ..._orders.where((o) => o.isCompleted),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("주문 테이블")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: sortedOrders.length,
              itemBuilder: (context, index) {
                return OrderRowWidget(
                  order: sortedOrders[index],
                  onChanged: _updateOrder,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    List<int> totalMenuCounts = List.generate(3, (_) => 0);
    for (var order in _orders) {
      for (int i = 0; i < 3; i++) {
        totalMenuCounts[i] += order.menuQuantities[i];
      }
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
              child: Text("메뉴 ${i + 1} (잔여: ${totalMenuCounts[i]}개)",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            );
          }),
          const Expanded(flex: 2, child: Text("결제 확인", style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
