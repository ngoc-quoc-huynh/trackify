import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:trackify/domain/models/category.dart';

final class NewExpense extends Equatable {
  const NewExpense({
    required this.description,
    required this.value,
    required this.category,
    required this.date,
  });

  final String description;
  final Decimal value;
  final ExpenseCategory category;
  final DateTime date;

  @override
  List<Object?> get props => [
    description,
    value,
    category,
    date,
  ];
}
