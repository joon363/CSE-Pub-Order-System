import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cse_pub_client/themes.dart';
import 'dart:convert';

class MenuItem {
  final String name;
  final int index;
  final int price;
  final String imageUrl;

  MenuItem({required this.name, required this.index, required this.price, required this.imageUrl});
}
class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final TextEditingController _tableController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  List<int> menuCounts = [0,0,0];
  bool isChecked = false;
  final List<MenuItem> menuItems = [
    MenuItem(name: '삼겹살 (100g)', index: 0, price: 6500, imageUrl: 'assets/samg.jpg'),
    MenuItem(name: '껍데기 (100g)', index: 1, price: 5500, imageUrl: 'assets/ggup.jpg'),
    MenuItem(name: '비빔면', index: 2, price: 3000, imageUrl: 'assets/bibim.jpg'),
    MenuItem(name: '불닭게티(2인분)', index: 3, price: 5500, imageUrl: 'assets/buldark.jpg'),
    MenuItem(name: '세트A', index: 4, price: 5000, imageUrl: 'assets/setA.png'),
    MenuItem(name: '세트B', index: 5, price: 3500, imageUrl: 'assets/setB.png'),
  ];
  Map<MenuItem, int> order = {};

  void addToOrder(MenuItem item) {
    setState(() {
      order[item] = (order[item] ?? 0) + 1;
      menuCounts[item.index]++;
    });
  }
  void increaseQty(MenuItem item) {
    addToOrder(item);
  }

  void decreaseQty(MenuItem item) {
    setState(() {
      menuCounts[item.index];
      if (order.containsKey(item)) {
        if (order[item]! > 1) {
          order[item] = order[item]! - 1;
          menuCounts[item.index]--;
        } else {
          order.remove(item);
          menuCounts[item.index]=0;
        }
      }
    });
  }

  int get totalPrice {
    int total = 0;
    order.forEach((item, qty) {
      total += item.price * qty;
    });
    return total;
  }
  Future<void> _showMessage(String text) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
  Future<void> _submitOrder() async {
    if (totalPrice == 0) {
      _showMessage('메뉴를 선택하세요');
      return;
    }
    final table = _tableController.text.trim();

    if (table.isEmpty) {
      _showMessage('테이블 번호를 입력하세요');
      return;
    }
    final tableNumber = int.tryParse(table);
    if (tableNumber == null || tableNumber < 1 || tableNumber > 14) {
      _showMessage('1부터 14 사이의 숫자를 입력하세요');
      return;
    }
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showMessage('이름을 입력하세요');
      return;
    }
    if (isChecked == false) {
      _showMessage('입금 후 체크해주세요');
      return;
    }

    final Map<String, dynamic> newOrder = {
      "income": totalPrice,
      "time": TimeOfDay.now().format(context),
      "name": name,
      "menus": {
        "menu1": {"count": menuCounts[0], "checked": false},
        "menu2": {"count": menuCounts[1], "checked": false},
        "menu3": {"count": menuCounts[2], "checked": false}
      },
      "paid": false
    };

    final response = await http.post(
      Uri.parse("http://localhost:5000/orders/new"), // 서버 주소 수정 가능
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(newOrder),
    );

    if (response.statusCode == 201) {
      _showMessage('주문이 완료되었습니다!');
      setState(() {
        _nameController.clear();
        menuCounts = [0,0,0];
        order={};
      });
    } else {
      _showMessage('주문 실패: ${response.body}');
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColorLight
                  ),
                  height: 100,
                  child:
                  Image.asset(
                    'assets/cse.jpg',
                  ),
                ),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('미디움레어 작성원리', style: TextStyle(fontSize: 24),),
                  ],
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2열
                  childAspectRatio: 1/1,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return GestureDetector(
                    onTap: () => addToOrder(item),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(item.imageUrl, height: 120,),
                          const SizedBox(height: 8),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item.name, style: const TextStyle(fontSize: 14)),
                                Text('${item.price}원', style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(thickness: 2),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12)
              ),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Expanded(child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('메뉴', style: TextStyle(fontWeight: FontWeight.bold)),
                      )),
                      SizedBox(width: 100, child: Center(child: Text('수량', style: TextStyle(fontWeight: FontWeight.bold)))),
                      SizedBox(width: 80, child: Center(child: Text('금액', style: TextStyle(fontWeight: FontWeight.bold)))),
                    ],
                  ),
                  ...order.entries.map((entry) {
                    final item = entry.key;
                    final qty = entry.value;
                    return Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item.name),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => decreaseQty(item),
                              ),
                              Text('$qty'),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => increaseQty(item),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Center(
                            child: Text('${item.price * qty}원'),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  const Divider(),
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      const SizedBox(width: 60),
                      SizedBox(
                        width: 100,
                        child: Center(
                          child: Text('합계 ${totalPrice}원', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Column(
                  children: [
                    TextField(
                      controller: _tableController,
                      decoration: InputDecoration(labelText: '테이블 번호 입력'),
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: '입금자명 입력'),
                    )
                  ],
                )),
                SizedBox(width: 20),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('입금하였습니다!'),
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          isChecked = newValue ?? false;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: _submitOrder,
                      child: Text('주문하기', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
