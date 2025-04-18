import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(OrderApp());

class OrderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OrderPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final TextEditingController _nameController = TextEditingController();
  int menu1Count = 0;
  int menu2Count = 0;
  int menu3Count = 0;

  int get totalPrice =>
      menu1Count * 5000 + menu2Count * 3000 + menu3Count * 2000;

  Future<void> _submitOrder() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || totalPrice == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이름을 입력하고 메뉴를 선택하세요')),
      );
      return;
    }

    final Map<String, dynamic> newOrder = {
      "income": totalPrice,
      "time": TimeOfDay.now().format(context),
      "name": name,
      "menus": {
        "menu1": {"count": menu1Count, "checked": false},
        "menu2": {"count": menu2Count, "checked": false},
        "menu3": {"count": menu3Count, "checked": false}
      },
      "paid": false
    };

    final response = await http.post(
      Uri.parse("http://localhost:5000/orders/new"), // 서버 주소 수정 가능
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(newOrder),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('주문이 완료되었습니다!')),
      );
      setState(() {
        _nameController.clear();
        menu1Count = 0;
        menu2Count = 0;
        menu3Count = 0;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('주문 실패: ${response.body}')),
      );
    }
  }

  Widget _menuCounter(String title, int count, void Function() onAdd, void Function() onRemove) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 18)),
        Row(
          children: [
            IconButton(icon: Icon(Icons.remove), onPressed: onRemove),
            Text('$count', style: TextStyle(fontSize: 18)),
            IconButton(icon: Icon(Icons.add), onPressed: onAdd),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('주문하기')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '이름 입력'),
            ),
            SizedBox(height: 20),
            _menuCounter("메뉴1 (₩5000)", menu1Count, () {
              setState(() => menu1Count++);
            }, () {
              setState(() {
                if (menu1Count > 0) menu1Count--;
              });
            }),
            _menuCounter("메뉴2 (₩3000)", menu2Count, () {
              setState(() => menu2Count++);
            }, () {
              setState(() {
                if (menu2Count > 0) menu2Count--;
              });
            }),
            _menuCounter("메뉴3 (₩2000)", menu3Count, () {
              setState(() => menu3Count++);
            }, () {
              setState(() {
                if (menu3Count > 0) menu3Count--;
              });
            }),
            SizedBox(height: 30),
            Text('총 가격: ₩$totalPrice', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitOrder,
              child: Text('주문하기', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
