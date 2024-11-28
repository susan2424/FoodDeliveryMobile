void _saveOrderPlan() async {
  double totalCost = 0.0;
  for (int foodItemId in selectedFoodItems) {
    var foodItem = foodItems.firstWhere((item) => item['id'] == foodItemId);
    totalCost += foodItem['price'];
  }

  if (selectedDate.isNotEmpty && selectedFoodItems.isNotEmpty && totalCost <= targetCost) {
    // Convert selected food items' IDs to a string
    String selectedFoodItemsString = selectedFoodItems.join(', ');
    await dbHelper.saveOrderPlan(selectedDate, targetCost, selectedFoodItemsString);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order plan saved successfully!')));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Exceeds target cost or missing info!')));
  }
}
