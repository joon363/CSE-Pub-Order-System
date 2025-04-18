class Order {
  final int id;
  final int income;
  final String time;
  final String name;
  final List<int> menuQuantities;
  final List<bool> menuChecked;
  bool isPaid;

  Order({
    required this.id,
    required this.income,
    required this.time,
    required this.name,
    required this.menuQuantities,
    required this.menuChecked,
    required this.isPaid,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final menus = json['menus'] as Map<String, dynamic>;

    // 메뉴 key의 정렬된 순서를 보장
    final sortedMenuKeys = ['menu1', 'menu2', 'menu3'];

    final quantities = <int>[];
    final checked = <bool>[];

    for (var key in sortedMenuKeys) {
      quantities.add(menus[key]['count'] as int);
      checked.add(menus[key]['checked'] as bool);
    }

    return Order(
      id: json['id'] as int,
      income: json['income'] as int,
      time: json['time'] as String,
      name: json['name'] as String,
      menuQuantities: quantities,
      menuChecked: checked,
      isPaid: json['paid'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    final menuMap = <String, dynamic>{};

    final sortedMenuKeys = ['menu1', 'menu2', 'menu3'];

    for (int i = 0; i < sortedMenuKeys.length; i++) {
      menuMap[sortedMenuKeys[i]] = {
        'checked': menuChecked[i],
        'count': menuQuantities[i],
      };
    }

    return {
      'id': id,
      'income': income,
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
