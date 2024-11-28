class Order {
  final String foodItem;
  final double price;
  final String date;

  // Constructor
  Order({
    required this.foodItem,
    required this.price,
    required this.date,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      foodItem: map['food_item'],  // entry for the food item label
      price: map['price'], // entry for the food price label
      date: map['date'], // entry for the calendar by date
    );
  }

  // translates the food order into a Map
  Map<String, dynamic> toMap() {
    return {
      'food_item': foodItem,
      'price': price,
      'date': date,
    };
  }
}
