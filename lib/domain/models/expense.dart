import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:trackify/domain/models/category.dart';

final class Expense extends Equatable {
  const Expense({
    required this.id,
    required this.description,
    required this.value,
    required this.category,
    required this.date,
  });

  final int id;
  final String description;
  final Decimal value;
  final ExpenseCategory category;
  final DateTime date;

  @override
  List<Object?> get props => [
    id,
    description,
    value,
    category,
    date,
  ];
}
