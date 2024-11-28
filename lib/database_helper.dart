import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "food_ordering.db";
  static final _databaseVersion = 1;

  static final table = 'food_items';
  static final orderPlansTable = 'order_plans'; // the table to allow food ordering

  static final columnId = 'id';
  static final columnName = 'name';
  static final columnPrice = 'price';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    // starts the DB on startup
    _database = await _initDatabase();
    return _database!;
  }

  // creates a table if not already
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // enables the table when the DB is done
  Future _onCreate(Database db, int version) async {
    // food item table
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnPrice REAL NOT NULL
      )
    ''');

    // order plan table
    await db.execute('''
      CREATE TABLE $orderPlansTable (
        id INTEGER PRIMARY KEY,
        date TEXT NOT NULL,
        targetCost REAL NOT NULL,
        selectedFoodItems TEXT NOT NULL
      )
    ''');
  }

  // the following food item choices
  Future<void> insertFoodItems() async {
    final db = await database;
    List<Map<String, dynamic>> foodItems = [
      {'name': 'Pizza', 'price': 8.99},
      {'name': 'Burger', 'price': 5.49},
      {'name': 'Pasta', 'price': 7.99},
      {'name': 'Salad', 'price': 4.99},
      {'name': 'Sushi', 'price': 12.99},
      {'name': 'Steak', 'price': 15.99},
      {'name': 'Chicken Wings', 'price': 6.49},
      {'name': 'Hot Dog', 'price': 3.99},
      {'name': 'Ice Cream', 'price': 2.99},
      {'name': 'Fries', 'price': 2.49},
      {'name': 'Soup', 'price': 5.99},
      {'name': 'Tacos', 'price': 6.99},
      {'name': 'Fried Rice', 'price': 7.49},
      {'name': 'Wrap', 'price': 8.49},
      {'name': 'Lasagna', 'price': 9.99},
      {'name': 'Quiche', 'price': 8.79},
      {'name': 'Mussels', 'price': 13.49},
      {'name': 'Ramen', 'price': 11.99},
      {'name': 'Burger & Fries', 'price': 7.49},
      {'name': 'Cheeseburger', 'price': 6.99},
    ];

    for (var item in foodItems) {
      await db.insert(table, item);
    }
  }

  // gets the required items from the DB
  Future<List<Map<String, dynamic>>> getFoodItems() async {
    final db = await database;
    return await db.query(table);
  }

  // uses the calendar to retrieve any needed orders
  Future<List<Map<String, dynamic>>> getOrderPlansByDate(String date) async {
    final db = await database;
    return await db.query(
      orderPlansTable,
      where: 'date = ?',
      whereArgs: [date],
    );
  }

  // allows user to save the order
  Future<void> saveOrderPlan(String date, double targetCost, String selectedFoodItems) async {
    final db = await database;
    await db.insert(
      orderPlansTable,
      {
        'date': date,
        'targetCost': targetCost,
        'selectedFoodItems': selectedFoodItems,
      },
    );
  }
}
