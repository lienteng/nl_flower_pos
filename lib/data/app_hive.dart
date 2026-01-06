import 'package:hive_flutter/hive_flutter.dart';
import 'package:ln_flower/data/app_boxes.dart';

class AppHive {
  static Future<void> init() async {
    await Hive.initFlutter();

    await Hive.openBox<Map>(AppBoxes.income);
    await Hive.openBox<Map>(AppBoxes.expense);
    await Hive.openBox<Map>(AppBoxes.shopProfile);
    await Hive.openBox<Map>(AppBoxes.customers);
    await Hive.openBox<Map>(AppBoxes.shippingCompanies);
    await Hive.openBox<Map>(AppBoxes.expenseCategories);
    await Hive.openBox<Map>(AppBoxes.waybills);
  }
}
