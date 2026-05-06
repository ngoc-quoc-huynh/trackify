import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite_async/sqlite_async.dart';
import 'package:trackify/domain/models/category.dart';
import 'package:trackify/domain/models/expense.dart';
import 'package:trackify/domain/models/new_expense.dart';
import 'package:trackify/infrastructure/repositories/expense.dart';

void main() {
  late SqliteDatabase db;
  late ExpenseRepositoryImpl repository;

  setUp(() async {
    final connection = SqliteDatabase.singleConnection(
      SqliteConnection.synchronousWrapper(sqlite3.openInMemory()),
    );
    db = SqliteDatabase.singleConnection(connection);
    repository = ExpenseRepositoryImpl(db);
    await repository.init();
  });

  tearDown(() async {
    await db.close();
  });

  test('creates table', () async {
    final row = await db.get(
      '''
SELECT EXISTS (
  SELECT 1
  FROM sqlite_master
  WHERE type = 'table'
    AND name = ?
) AS table_exists
''',
      [ExpenseRepositoryImpl.tableName],
    );
    expect(row['table_exists'], 1);
  });

  test('deletes expense', () async {
    final saved = await repository.save(
      NewExpense(
        description: '',
        category: ExpenseCategory.other,
        value: Decimal.fromInt(1),
        date: DateTime.utc(2026, 5, 5),
      ),
    );

    await repository.delete(saved.id);

    final expenses = await repository.getAll();

    expect(expenses, isEmpty);
  });

  test('saves expense', () async {
    final expense = await repository.save(
      NewExpense(
        description: '',
        category: ExpenseCategory.other,
        value: Decimal.fromInt(1),
        date: DateTime.utc(2026, 5, 5),
      ),
    );

    expect(
      expense,
      Expense(
        id: 1,
        description: '',
        category: ExpenseCategory.other,
        value: Decimal.fromInt(1),
        date: DateTime.utc(2026, 5, 5),
      ),
    );
  });

  group('getAll', () {
    test('returns empty list when there are no expenses', () async {
      final expenses = await repository.getAll();

      expect(expenses, isEmpty);
    });

    test('getAll returns expenses ordered by date desc and id desc', () async {
      final oldExpense = await repository.save(
        NewExpense(
          description: 'Old',
          category: ExpenseCategory.other,
          value: Decimal.fromInt(1),
          date: DateTime.utc(2026, 5, 5),
        ),
      );

      final newExpense = await repository.save(
        NewExpense(
          description: 'New',
          category: ExpenseCategory.other,
          value: Decimal.fromInt(1),
          date: DateTime.utc(2026, 5, 6),
        ),
      );

      final newExpense2 = await repository.save(
        NewExpense(
          description: 'New 2',
          category: ExpenseCategory.other,
          value: Decimal.fromInt(1),
          date: DateTime.utc(2026, 5, 6),
        ),
      );

      final expenses = await repository.getAll();

      expect(
        expenses.map((expense) => expense.id),
        [
          newExpense2.id,
          newExpense.id,
          oldExpense.id,
        ],
      );
    });

    // TODO: Add tests for category filter
  });
}
