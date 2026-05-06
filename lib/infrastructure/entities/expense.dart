import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:trackify/domain/models/category.dart';
import 'package:trackify/domain/models/expense.dart';

final class ExpenseEntity extends Equatable {
  const ExpenseEntity({
    required this.id,
    required this.description,
    required this.category,
    required this.value,
    required this.date,
  });

  factory ExpenseEntity.fromRow(Map<String, dynamic> row) => switch (row) {
    {
      'id': final int id,
      'description': final String description,
      'category': final String category,
      'value': final String value,
      'date': final String date,
    } =>
      ExpenseEntity(
        id: id,
        description: description,
        category: category,
        value: value,
        date: date,
      ),
    _ => throw const FormatException('Invalid expense row'),
  };

  final int id;
  final String description;
  final String category;
  final String value;
  final String date;

  Expense toDomain() => Expense(
    id: id,
    description: description,
    category: ExpenseCategory.values.byName(category),
    value: Decimal.parse(value),
    date: DateTime.parse(date),
  );

  @override
  List<Object?> get props => [
    id,
    description,
    category,
    value,
    date,
  ];
}
