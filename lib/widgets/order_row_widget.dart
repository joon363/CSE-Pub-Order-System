import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderRowWidget extends StatefulWidget {
  final Order order;
  final ValueChanged<Order> onChanged;

  const OrderRowWidget({
    super.key,
    required this.order,
    required this.onChanged,
  });

  @override
  State<OrderRowWidget> createState() => _OrderRowWidgetState();
}

class _OrderRowWidgetState extends State<OrderRowWidget> {
  late Order _order;

  @override
  void initState() {
    super.initState();
    _order = widget.order;
  }

  void _toggleMenuCheck(int index, bool? checked) {
    setState(() {
      if (checked == true && _order.menuChecked[index] < _order.menuQuantities[index]) {
        _order.menuChecked[index]++;
      } else if (checked == false && _order.menuChecked[index] > 0) {
        _order.menuChecked[index]--;
      }
    });
    widget.onChanged(_order);
  }

  void _togglePayment(bool? checked) {
    setState(() {
      _order.isPaid = checked ?? false;
    });
    widget.onChanged(_order);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _order.isCompleted ? Colors.grey[300] : null,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(_order.time)),
          Expanded(flex: 2, child: Text(_order.name)),
          ...List.generate(3, (i) {
            if (_order.menuQuantities[i] == 0) return const Expanded(flex: 3, child: SizedBox());
            return Expanded(
              flex: 3,
              child: Checkbox(
                value: _order.menuChecked[i] < _order.menuQuantities[i],
                onChanged: (val) => _toggleMenuCheck(i, val),
              ),
            );
          }),
          Expanded(
            flex: 2,
            child: Checkbox(
              value: _order.isPaid,
              onChanged: _togglePayment,
            ),
          ),
        ],
      ),
    );
  }
}
