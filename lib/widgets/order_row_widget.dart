import 'package:flutter/material.dart';
import '../models/order.dart';
import 'package:cse_pub_client/models/menus.dart';

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
      _order.menuChecked[index]=checked??false;
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
          Expanded(flex: 2, child: Text(_order.tableID.toString())),
          ...List.generate(menuCount, (i) {
            if (_order.menuQuantities[i] == 0) return const Expanded(flex: 3, child: SizedBox());
            return Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${_order.menuQuantities[i]}'),
                    Checkbox(
                      value: _order.menuChecked[i],
                      onChanged: (val) => _toggleMenuCheck(i, val),
                    ),
                  ],)
            );
          }),
          Expanded(
            flex: 2,
            child: Checkbox(
              value: _order.isPaid,
              onChanged: _togglePayment,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text('${_order.income}', textAlign: TextAlign.center,),
          ),
        ],
      ),
    );
  }
}