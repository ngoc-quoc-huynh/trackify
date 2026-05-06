import 'package:trackify/domain/models/category.dart';
import 'package:trackify/domain/models/expense.dart';
import 'package:trackify/domain/models/new_expense.dart';

abstract interface class ExpenseRepository {
  const ExpenseRepository();

  Future<void> delete(int id);

  Future<List<Expense>> getAll([ExpenseCategory? category]);

  Future<Expense> save(NewExpense newExpense);
}
