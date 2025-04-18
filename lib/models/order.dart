class Order {
  final String id;
  final String time;
  final String name;
  final List<int> menuQuantities;
  final List<int> menuChecked;
  bool isPaid;

  Order({
    required this.id,
    required this.time,
    required this.name,
    required this.menuQuantities,
    required this.menuChecked,
    required this.isPaid,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      time: json['time'],
      name: json['name'],
      menuQuantities: List<int>.from(json['menuQuantities']),
      menuChecked: List<int>.from(json['menuChecked']),
      isPaid: json['isPaid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'name': name,
      'menuQuantities': menuQuantities,
      'menuChecked': menuChecked,
      'isPaid': isPaid,
    };
  }

  bool get isCompleted {
    for (int i = 0; i < menuQuantities.length; i++) {
      if (menuChecked[i] < menuQuantities[i]) return false;
    }
    return true;
  }
}
