import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ln_flower/data/app_boxes.dart';
import 'package:ln_flower/data/records.dart';

class RecordRepository {
  const RecordRepository();

  Box<Map> get _incomeBox => Hive.box<Map>(AppBoxes.income);
  Box<Map> get _expenseBox => Hive.box<Map>(AppBoxes.expense);
  Box<Map> get _shippingCompanyBox => Hive.box<Map>(AppBoxes.shippingCompanies);
  Box<Map> get _expenseCategoryBox => Hive.box<Map>(AppBoxes.expenseCategories);

  ValueListenable<Box<Map>> incomeListenable() => _incomeBox.listenable();
  ValueListenable<Box<Map>> expenseListenable() => _expenseBox.listenable();
  ValueListenable<Box<Map>> shippingCompanyListenable() =>
      _shippingCompanyBox.listenable();
  ValueListenable<Box<Map>> expenseCategoryListenable() =>
      _expenseCategoryBox.listenable();

  Future<void> addIncome(IncomeRecord record) async {
    await _incomeBox.put(record.id, record.toMap());
  }

  Future<void> addExpense(ExpenseRecord record) async {
    await _expenseBox.put(record.id, record.toMap());
  }

  // Expense Category methods
  Future<void> addExpenseCategory(ExpenseCategory category) async {
    await _expenseCategoryBox.put(category.id, category.toMap());
  }

  Future<void> updateExpenseCategory(ExpenseCategory category) async {
    await _expenseCategoryBox.put(category.id, category.toMap());
  }

  Future<void> deleteExpenseCategory(String id) async {
    await _expenseCategoryBox.delete(id);
  }

  ExpenseCategory? getExpenseCategory(String id) {
    final map = _expenseCategoryBox.get(id);
    return map != null ? ExpenseCategory.fromMap(map) : null;
  }

  List<ExpenseCategory> getExpenseCategories() {
    return _expenseCategoryBox.values.map(ExpenseCategory.fromMap).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future<void> initializeDefaultExpenseCategories() async {
    if (_expenseCategoryBox.isEmpty) {
      for (final category in ExpenseCategory.getDefaultCategories()) {
        await addExpenseCategory(category);
      }
    }
  }

  // Shipping Company methods
  Future<void> addShippingCompany(ShippingCompany company) async {
    await _shippingCompanyBox.put(company.id, company.toMap());
  }

  Future<void> updateShippingCompany(ShippingCompany company) async {
    await _shippingCompanyBox.put(company.id, company.toMap());
  }

  Future<void> deleteShippingCompany(String id) async {
    await _shippingCompanyBox.delete(id);
  }

  ShippingCompany? getShippingCompany(String id) {
    final map = _shippingCompanyBox.get(id);
    return map != null ? ShippingCompany.fromMap(map) : null;
  }

  List<ShippingCompany> getShippingCompanies() {
    return _shippingCompanyBox.values.map(ShippingCompany.fromMap).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future<void> initializeDefaultShippingCompanies() async {
    if (_shippingCompanyBox.isEmpty) {
      for (final company in ShippingCompany.getDefaultCompanies()) {
        await addShippingCompany(company);
      }
    }
  }

  double totalIncome({DateTime? from, DateTime? to}) {
    return _incomeBox.values
        .map(IncomeRecord.fromMap)
        .where((r) => _inRange(r.createdAt, from, to))
        .fold<double>(0, (sum, r) => sum + r.amount);
  }

  double totalExpense({DateTime? from, DateTime? to}) {
    return _expenseBox.values
        .map(ExpenseRecord.fromMap)
        .where((r) => _inRange(r.createdAt, from, to))
        .fold<double>(0, (sum, r) => sum + r.amount);
  }

  static bool _inRange(DateTime value, DateTime? from, DateTime? to) {
    if (from != null && value.isBefore(from)) return false;
    if (to != null && value.isAfter(to)) return false;
    return true;
  }
}
