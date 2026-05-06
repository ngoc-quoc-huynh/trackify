import 'package:flutter/foundation.dart';
import 'package:sqlite_async/sqlite_async.dart';
import 'package:trackify/domain/interfaces/expense.dart';
import 'package:trackify/domain/models/expense.dart';
import 'package:trackify/domain/models/new_expense.dart';
import 'package:trackify/infrastructure/entities/expense.dart';

final class ExpenseRepositoryImpl implements ExpenseRepository {
  const ExpenseRepositoryImpl(this._db);

  final SqliteDatabase _db;

  @visibleForTesting
  static const tableName = 'expenses';
  static final _migrations = SqliteMigrations()
    ..add(
      SqliteMigration(1, (tx) async {
        await tx.execute(
          '''
CREATE TABLE $tableName (
  id INTEGER PRIMARY KEY,
  description TEXT NOT NULL,
  category TEXT NOT NULL,
  value TEXT NOT NULL,
  date TEXT NOT NULL
)
''',
        );
      }),
    );

  Future<void> init() => _migrations.migrate(_db);

  @override
  Future<void> delete(int id) => _db.execute(
    '''
DELETE FROM $tableName
WHERE id = ?
''',
    [id],
  );

  @override
  Future<List<Expense>> getAll() async {
    final rows = await _db.getAll('''
SELECT id, description, category, value, date
FROM $tableName
ORDER BY date DESC, id DESC
    ''');

    return rows
        .map((row) => ExpenseEntity.fromRow(row).toDomain())
        .toList(growable: false);
  }

  @override
  Future<Expense> save(NewExpense newExpense) async {
    final rows = await _db.execute(
      '''
INSERT INTO $tableName (description, category, value, date)
VALUES (?, ?, ?, ?)
RETURNING id, description, category, value, date''',
      [
        newExpense.description,
        newExpense.category.name,
        newExpense.value.toString(),
        newExpense.date.toUtc().toIso8601String(),
      ],
    );

    return ExpenseEntity.fromRow(rows.first).toDomain();
  }
}
